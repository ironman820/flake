{ flakeRoot, self, ... }: {
  flake.nixosModules.rcm-work = { config, pkgs, ... }: {
    microvm.vms.rcm-work = {
      inherit pkgs;
      config =
        let
          inherit (pkgs) lib;
        in
        {
          imports = with self.nixosModules; [
            microvms-base
            rcm
          ];
          environment.systemPackages = with pkgs; [
            sonar-scanner-cli
          ];
          home-manager.users.ironman = self.homeConfigurations.ironman-server;
          microvm = {
            interfaces = [
              {
                id = "vm-rcm";
                mac =
                  let
                    hash = builtins.hashString "sha256" "rcm-work";
                    octets = lib.genList (i: builtins.substring (i * 2) 2 hash) 5;
                  in
                  "02:${lib.concatStringsSep ":" octets}";
                type = "tap";
                tap.vhost = true;
              }
            ];
            mem = 8 * 1024;
            vcpu = 2;
            volumes = [
              {
                image = "root.ext4";
                mountPoint = "/";
                size = 32 * 1024;
              }
            ];
            vsock.cid = 4;
          };
          networking = {
            firewall.enable = false;
            hostName = "rcm-work";
          };
          nix = {
            optimise.automatic = lib.mkForce false;
            settings = {
              auto-optimise-store = lib.mkForce false;
              cores = 1;
            };
          };
          security.sudo.wheelNeedsPassword = false;
          services = {
            openssh.settings.PermitRootLogin = "no";
            qemuGuest.enable = true;
          };
          sops.secrets."sonar-project.properties" = {
            sopsFile = "${flakeRoot}/.secrets/rcm.yaml";
            owner = config.ironman.user.name;
            group = config.ironman.user.name;
            path = "/data/rcm/sonar-project.properties";
          };
          systemd.network = {
            enable = true;
            networks."20-lan" = {
              matchConfig.Type = "ether";
              networkConfig = {
                Address = [
                  "192.168.20.101/23"
                ];
                Gateway = "192.168.20.1";
                DNS = [
                  "192.168.20.2"
                ];
                DHCP = "no";
              };
            };
          };
        };
    };
  };
}
