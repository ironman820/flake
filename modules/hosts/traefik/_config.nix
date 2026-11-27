{ config, lib, ... }:
let
  entryPoints = "https";
  tls = { };
in
{
  ironman = {
    kcc.ip = "192.168.248.124";
    lidarr.ip = "192.168.248.113";
    radarr.ip = "192.168.248.123";
    rcm.ip = "192.168.248.121";
    slsk.ip = "192.168.248.125";
    sonarqube.ip = "192.168.248.107";
    sonobarr.ip = "192.168.248.117";
  };
  hardware.facter.reportPath = ./facter.json;
  networking = {
    hostName = "traefik";
    nameservers = [
      "208.80.144.50"
      "208.80.144.51"
    ];
  };
  services = {
    openssh.ports = [
      2222
    ];
    traefik = {
      dynamicConfigOptions = {
        http = {
          routers = {
            dns = {
              inherit entryPoints tls;
              middlewares = "secured";
              rule = "Host(`pdns.home.niceastman.com`)";
              service = "dns";
            };
            files = {
              inherit entryPoints tls;
              middlewares = "default-headers";
              rule = "Host(`myshare.niceastman.com`)";
              service = "zipline";
            };
            huntarr = {
              inherit entryPoints tls;
              middlewares = "secured";
              rule = "Host(`huntarr.home.niceastman.com`)";
              service = "huntarr";
            };
            jellyfin = {
              inherit entryPoints tls;
              middlewares = "default-headers";
              rule = "Host(`mymedia.niceastman.com`)";
              service = "jellyfin";
            };
            nas = {
              inherit entryPoints tls;
              middlewares = "secured";
              rule = "Host(`nas.home.niceastman.com`)";
              service = "nas";
            };
            prowlarr = {
              inherit entryPoints tls;
              middlewares = "secured";
              rule = "Host(`prowlarr.home.niceastman.com`)";
              service = "prowlarr";
            };
            pve = {
              inherit entryPoints tls;
              middlewares = "proxmox";
              rule = "Host(`pve.home.niceastman.com`)";
              service = "pve";
            };
            pve2 = {
              inherit entryPoints tls;
              middlewares = "proxmox";
              rule = "Host(`pve2.home.niceastman.com`)";
              service = "pve2";
            };
            rcm2 = {
              inherit entryPoints tls;
              middlewares = "secured";
              rule = "Host(`rcm2.home.niceastman.com`)";
              service = "rcm2";
            };
            sonarr = {
              inherit entryPoints tls;
              middlewares = "secured";
              rule = "Host(`sonarr.home.niceastman.com`)";
              service = "sonarr";
            };
            sonarr2 = {
              inherit entryPoints tls;
              middlewares = "secured";
              rule = "Host(`sonarr2.home.niceastman.com`)";
              service = "sonarr2";
            };
            sync = {
              inherit entryPoints tls;
              middlewares = "secured";
              rule = "Host(`sync.home.niceastman.com`)";
              service = "syncthing";
            };
            torrent = {
              inherit entryPoints tls;
              middlewares = "secured";
              rule = "Host(`torrent.home.niceastman.com`)";
              service = "qbittorrent";
            };
            torrent2 = {
              inherit entryPoints tls;
              middlewares = "secured";
              rule = "Host(`torrent2.home.niceastman.com`)";
              service = "qbittorrent2";
            };
            ups = {
              inherit entryPoints tls;
              middlewares = "secured";
              rule = "Host(`ups.home.niceastman.com`)";
              service = "peanut";
            };
            vaultwarden = {
              inherit entryPoints tls;
              middlewares = "vaultwarden";
              rule = "Host(`pass.niceastman.com`)";
              service = "vaultwarden";
            };
          };
          services = {
            dns.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.2:5380";
                }
              ];
              serversTransport = "insecure";
            };
            huntarr.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.116:9705";
                }
              ];
              serversTransport = "insecure";
            };
            jellyfin.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.111:8096";
                }
              ];
              serversTransport = "insecure";
            };
            nas.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "https://192.168.248.13:5001";
                }
              ];
              serversTransport = "insecure";
            };
            peanut.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.200:8080";
                }
              ];
            };
            prowlarr.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.112:9696";
                }
              ];
              serversTransport = "insecure";
            };
            pve.loadBalancer = {
              passhostheader = true;
              servers = [
                {
                  url = "https://192.168.248.11:8006";
                }
              ];
              serverstransport = "insecure";
            };
            pve2.loadBalancer = {
              passhostheader = true;
              servers = [
                {
                  url = "https://192.168.248.12:8006";
                }
              ];
              serverstransport = "insecure";
            };
            qbittorrent.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.104:8080";
                }
              ];
              serversTransport = "insecure";
            };
            qbittorrent2.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.104:8081";
                }
              ];
              serversTransport = "insecure";
            };
            rcm2.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.118:8000";
                }
              ];
              serversTransport = "insecure";
            };
            sonarr.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.109:8989";
                }
              ];
            };
            sonarr2.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.110:8989";
                }
              ];
            };
            syncthing.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.13:8384";
                }
              ];
              serversTransport = "insecure";
            };
            vaultwarden.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.108:8000";
                }
              ];
              serversTransport = "insecure";
            };
            zipline.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.103:3000";
                }
              ];
              serversTransport = "insecure";
            };
          };
          serversTransports.insecure.insecureSkipVerify = true;
        };
        tcp = {
          routers.ssh = {
            entryPoints = "ssh";
            rule = "HostSNI(`*`)";
            service = "git-ssh";
          };
          services.git-ssh.loadBalancer.servers = [
            {
              address = "192.168.248.13:22";
            }
          ];
        };
      };
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
          ssh.address = ":22";
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
      };
    };
  };
  topology =
    let
      inherit (config.lib.topology) mkConnection;
    in
    {
      id = "traefik";
      self = {
        interfaces.eth0 = {
          addresses = [
            "192.168.248.10"
          ];
          network = "home";
          physicalConnections = [
            (mkConnection "pve" "vmbr0")
          ];
        };
        deviceType = "nixos";
        guestType = "nixos-container";
        name = "Traefik";
        parent = "pve";
      };
    };
}
