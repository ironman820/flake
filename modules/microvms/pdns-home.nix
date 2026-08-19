{
  flake.nixosModules.pdns-home =
    { pkgs, ... }:
    {
      microvm.vms.pdns-home = {
        inherit pkgs;
        config =
          let
            inherit (pkgs) lib;
          in
          {
            microvm = {
              interfaces = [
                {
                  id = "vm-pdns";
                  mac = "02:00:00:00:00:01";
                  tap.vhost = true;
                  type = "tap";
                }
              ];
              mem = 2 * 1000;
              shares = [
                {
                  source = "/nix/store";
                  mountPoint = "/nix/.ro-store";
                  tag = "ro-store";
                  proto = "virtiofs";
                }
              ];
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
            nix = {
              optimise.automatic = lib.mkForce false;
              settings = {
                auto-optimise-store = lib.mkForce false;
                cores = 1;
              };
            };
            networking = {
              firewall = {
                allowedTCPPorts = [
                  22
                  53
                  80
                  443
                  538
                  853
                  5380
                  53443
                ];
                allowedUDPPorts = [
                  53
                  538
                  853
                ];
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
              qemuGuest.enable = true;
              technitium-dns-server.enable = true;
              xserver.enable = false;
            };
            system.stateVersion = "25.05";
            systemd.network = {
              enable = true;
              networks."20-lan" = {
                matchConfig.Type = "ether";
                networkConfig = {
                  Address = [
                    "192.168.248.2/23"
                  ];
                  Gateway = "192.168.248.1";
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
