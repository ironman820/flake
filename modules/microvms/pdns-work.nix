{ self, ... }: {
  flake.nixosModules.pdns-work =
    { pkgs, ... }:
    {
      microvm.vms.pdns-work = {
        inherit pkgs;
        config =
          let
            inherit (pkgs) lib;
          in
          {
            imports = with self.nixosModules; [
              microvms-base
            ];
            home-manager.users.ironman = self.homeConfigurations.ironman-server;
            microvm = {
              interfaces = [
                {
                  id = "vm-pdns";
                  mac = "4D:50:44:4E:53:57";
                  type = "tap";
                  tap.vhost = true;
                }
              ];
              mem = 2 * 1000;
              vcpu = 2;
              volumes = [
                {
                  image = "root.ext4";
                  mountPoint = "/";
                  size = 5 * 1024;
                }
              ];
              vsock.cid = 3;
            };
            networking = {
              firewall.enable = false;
              hostName = "pdns-work";
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
              chrony = {
                enable = true;
                extraConfig = ''
                  allow
                '';
                servers = [
                  "208.91.182.74"
                ];
              };
              # openssh.settings.PermitRootLogin = "no";
              qemuGuest.enable = true;
              technitium-dns-server.enable = true;
              xserver.enable = false;
            };
            systemd.network = {
              enable = true;
              networks."20-lan" = {
                matchConfig.Type = "ether";
                networkConfig = {
                  Address = [
                    "192.168.20.2/23"
                  ];
                  Gateway = "192.168.20.1";
                  DNS = [
                    "208.80.144.50"
                    "208.80.144.51"
                  ];
                  DHCP = "no";
                };
              };
            };
          };
      };
    };
}
