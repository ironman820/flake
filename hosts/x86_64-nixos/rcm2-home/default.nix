{
  config,
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
  ]
  ++ (with self.nixosModules; [
    base
    git
    proxmox
    rcm2
    tmux
    x64-linux
  ]);
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  nix.settings.cores = 1;
  security.sudo.wheelNeedsPassword = false;
  services = {
    # nginx.virtualHosts."rcm2.home.niceastman.com" = {
    #   default = true;
    #   listen = [
    #     {
    #       addr = "0.0.0.0";
    #       port = 443;
    #       ssl = true;
    #     }
    #   ];
    #   locations = {
    #     "/".extraConfig = ''
    #       index index.html;
    #     '';
    #   };
    #   onlySSL = true;
    #   root = "/data/rcm";
    #   sslCertificate = config.sops.secrets.rcm_cert.path;
    #   sslCertificateKey = config.sops.secrets.rcm_key.path;
    # };
    qemuGuest.enable = true;
  };
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
}
