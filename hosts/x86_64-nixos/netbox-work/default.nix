{
  config,
  flakeRoot,
  pkgs,
  self,
  ...
}:
let
  pkgs-unstable = import self.inputs.nixpkgs {
    inherit (pkgs.stdenv.hostPlatform) system;
    overlays = [(final: prev: {
      netbox = pkgs.lib.makeOverridable (
        args:
        (prev.netbox.override args).overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            for f in netbox/templates/inc/table.html \
                    netbox/templates/inc/table_htmx.html; do
              [ -f "$f" ] && substituteInPlace "$f" \
                --replace "querystring table.prefixed_order_by_field=" \
                          "querystring_replace table.prefixed_order_by_field="
            done
          '';
        })
      ) { };
    })];
  };
in
{
  imports = [
    ./hardware.nix
  ]
  ++ (with self.nixosModules; [
    base
    git
    proxmox
    tmux
    x64-linux
  ]);
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  nix.settings.cores = 1;
  security.sudo.wheelNeedsPassword = false;
  services = {
    netbox = {
      enable = true;
      apiTokenPepperFiles = {
        "1" = config.sops.secrets.netbox-peppers.path;
      };
      package = pkgs-unstable.netbox;
      secretKeyFile = config.sops.secrets.netbox-key.path;
    };
    nginx = {
      enable = true;
      user = "netbox";
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts.netbox = {
        forceSSL = true;
        locations = {
          "/".proxyPass = "http://[::1]:8001";
          "/static/".alias = "${config.services.netbox.dataDir}/static/";
        };
        serverName = "netbox.desk.niceastman.com";
        sslCertificate = config.sops.secrets."certificate.pem".path;
        sslCertificateKey = config.sops.secrets."privatekey.pem".path;
      };
    };
    openssh.settings.PermitRootLogin = "no";
    qemuGuest.enable = true;
  };
  sops.secrets =
    let
      group = "netbox";
      owner = "netbox";
      sopsFile = "${flakeRoot}/.secrets/netbox.yaml";
    in
    {
      netbox-key = {
        inherit group owner sopsFile;
      };
      netbox-peppers = {
        inherit group owner sopsFile;
      };
      "certificate.pem" = {
        inherit group owner;
        sopsFile = "${flakeRoot}/.secrets/snakeoil.yaml";
      };
      "privatekey.pem" = {
        inherit group owner;
        sopsFile = "${flakeRoot}/.secrets/snakeoil.yaml";
      };
    };
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
}
