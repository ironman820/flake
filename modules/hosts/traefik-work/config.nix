{ self, ... }: {
  flake.nixosModules.traefikWorkConfig = { config, ... }: {
    hardware.facter.reportPath = ./facter.json;
    ironman = {
      guacamole.ip = "192.168.20.103";
      rcm = {
        domain = "desk";
        ip = "192.168.20.102";
      };
      rcm2 = {
        domain = "desk";
        ip = "192.168.20.104";
      };
      traefik.enable = true;
    };
    networking.hostName = "traefik-work";
    services.traefik = {
      enable = true;
      dynamicConfigOptions = {
        http = {
          routers = {
            dns = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`pdns.desk.niceastman.com`)";
              service = "dns";
              tls = { };
            };
            llama = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`llama.desk.niceastman.com`)";
              service = "llama";
              tls = { };
            };
            mail = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`mail.desk.niceastman.com`)";
              service = "mailhog";
              tls = { };
            };
            netbox = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`netbox.desk.niceastman.com`)";
              service = "netbox";
              tls = { };
            };
            pve = {
              entryPoints = "https";
              middlewares = "proxmox";
              rule = "Host(`pve.desk.niceastman.com`)";
              service = "pve";
              tls = { };
            };
          };
          services = {
            dns.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.20.2:5380";
                }
              ];
              serversTransport = "insecure";
            };
            llama.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.21.199:8080";
                }
              ];
            };
            mailhog.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.20.111:8025";
                }
              ];
              serversTransport = "insecure";
            };
            netbox.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "https://192.168.20.108";
                }
              ];
              serversTransport = "insecure";
            };
            pve.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "https://192.168.20.10:8006";
                }
              ];
              serverstransport = "insecure";
            };
          };
          serversTransports.insecure.insecureSkipVerify = true;
        };
      };
      environmentFiles = [
        config.sops.secrets."traefik.env".path
      ];
      staticConfigOptions = {
        entryPoints = {
          http = {
            address = ":80";
            forwardedHeaders.trustedIPs = [
              "127.0.0.1/32"
              "10.0.0.0/8"
              "192.168.0.0/16"
              "172.16.0.0/12"
            ];
            http.redirections.entryPoint = {
              to = "https";
              scheme = "https";
            };
          };
          https = {
            address = ":443";
            http.tls.certResolver = "letsencrypt";
            forwardedHeaders.trustedIPs = [
              "127.0.0.1/32"
              "10.0.0.0/8"
              "192.168.0.0/16"
              "172.16.0.0/12"
            ];
          };
          spice.address = ":3128";
          traefik.address = ":8080";
        };
        certificatesResolvers.cloudflare.acme = {
          email =
            let
              inherit (config.ironman.user.email) bob site;
            in
            "${bob}@${site}";
          dnsChallenge = {
            provider = "cloudflare";
            resolvers = [
              "1.1.1.1:53"
              "1.0.0.1:53"
            ];
          };
        };
        api = {
          dashboard = true;
          insecure = true;
        };
        experimental.plugins.htransformation = {
          moduleName = "github.com/tomMoulard/htransformation";
          version = "v0.3.3";
        };
        log = {
          filePath = "/var/log/traefik/traefik.log";
          format = "json";
          level = "ERROR";
        };
      };
    };
    sops.secrets."traefik.env" = {
      format = "binary";
      group = config.systemd.services.traefik.serviceConfig.Group;
      owner = config.systemd.services.traefik.serviceConfig.User;
      sopsFile = "${self.outPath}/.secrets/traefik.sops";
    };
    topology = {
      id = "traefik-work";
      self = {
        deviceType = "nixos";
        guestType = "nixos-container";
        name = "Traefik";
        parent = "pve-work";
      };
    };
  };
}
