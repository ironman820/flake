{
  cell,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  p = cell.nixosProfiles;
  v = config.vars;
in {
  imports = let
    profiles = with p; [
      static-ip
      traefik
      virtual-guest
    ];
    suites = cell.nixosSuites.server;
  in
    l.concatLists [
      [
        cell.bee
        cell.hardwareProfiles.traefik-work
      ]
      profiles
      suites
    ];

  home-manager.users.${v.username} = {
    imports = let
      inherit (inputs.cells.home) homeSuites;
      # h = inputs.cells.home.homeProfiles;
      profiles = [];
      suites = homeSuites.server;
    in
      l.concatLists [
        profiles
        suites
      ];
  };
  services.traefik = {
    dynamicConfigOptions = {
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
          proxmox2 = {
            entryPoints = "https";
            middlewares = "secured";
            rule = "Host(`pve2.desk.niceastman.com`)";
            service = "proxmox2";
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
          proxmox2.loadBalancer = {
            passHostHeader = true;
            servers = [
              {
                url = "https://192.168.20.252:8006";
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
    staticConfigOptions.entryPoints.spice.address = ":3128";
  };

  networking = {
    defaultGateway = "192.168.20.1";
    firewall.allowedTCPPorts = [
      3128
    ];
    hostName = "traefik-work";
    interfaces."ens18".ipv4.addresses = [
      {
        address = "192.168.20.4";
        prefixLength = 24;
      }
    ];
    nameservers = [
      "192.168.20.2"
    ];
  };
}
