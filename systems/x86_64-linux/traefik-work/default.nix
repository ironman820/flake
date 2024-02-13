{
  config,
  lib,
  ...
}: {
  imports = [
    ./hardware.nix
    ./networking.nix
  ];

  config = let
    inherit (lib) mkIf;
  in {
    mine = {
      servers.traefik = {
        config = {
          http = {
            routers = {
              pdns = {
                entryPoints = "https";
                middlewares = "secured";
                rule = "Host(`pdns.desk.niceastman.com`)";
                service = "pdns";
                tls = true;
              };
              proxmox = {
                entryPoints = "https";
                middlewares = "secured";
                rule = "Host(`pve.desk.niceastman.com`)";
                service = "proxmox";
                tls = true;
              };
              rcm = {
                entryPoints = "https";
                middlewares = "secured";
                rule = "Host(`rcm.desk.niceastman.com`)";
                service = "rcm";
                tls = true;
              };
              rcm2 = {
                entryPoints = "https";
                middlewares = "secured";
                rule = "Host(`rcm2.desk.niceastman.com`)";
                service = "rcm2";
                tls = true;
              };
              sonarqube = {
                entryPoints = "https";
                middlewares = "secured";
                rule = "Host(`qc.desk.niceastman.com`)";
                service = "sonarqube";
                tls = true;
              };
            };
            services = {
              pdns.loadBalancer = {
                passHostHeader = true;
                servers = [
                  {
                    url = "http://192.168.20.2:8000";
                  }
                ];
              };
              proxmox.loadBalancer = {
                passHostHeader = true;
                servers = [
                  {
                    url = "https://192.168.20.253:8006";
                  }
                ];
              };
              rcm.loadBalancer = {
                passHostHeader = true;
                servers = [
                  {
                    url = "https://192.168.20.5";
                  }
                ];
              };
              rcm2.loadBalancer = {
                passHostHeader = true;
                servers = [
                  {
                    url = "http://192.168.20.6";
                  }
                ];
              };
              sonarqube.loadBalancer = {
                passHostHeader = true;
                servers = [
                  {
                    url = "http://192.168.20.7:9000";
                  }
                ];
              };
            };
          };
          tcp = {
            routers.proxmox-spice = {
              entryPoints = "spice";
              rule = "HostSNI(`*`)";
              service = "proxmox-spice";
            };
            services.proxmox-spice.loadBalancer.servers = [
              {
                address = "192.168.20.253:3128";
              }
            ];
          };
        };
        enable = true;
        static.entryPoints.spice.address = ":3128";
      };
      suites.server.enable = true;
      virtual.guest.enable = true;
    };

    networking.firewall = mkIf config.mine.networking.firewall {
      allowedTCPPorts = [
        3128
      ];
    };

    system.stateVersion = "23.05";
  };
}
