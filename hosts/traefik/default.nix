{
  config,
  flakeRoot,
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
  ]
  ++ (with self.nixosModules; [
    git
    proxmox
    tmux
    x64-linux
  ]);
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
    2222
    3128
    8080
  ];
  security.sudo.wheelNeedsPassword = false;
  services = {
    openssh = {
      ports = [
        2222
      ];
      settings.PermitRootLogin = "no";
    };
    qemuGuest.enable = true;
    traefik = {
      enable = true;
      dynamicConfigOptions = {
        http = {
          middlewares = {
            guac-prefix.addprefix.prefix = "/guacamole";
            guacamole.chain.middlewares = [
              "guac-prefix"
              "private-whitelist"
              "default-headers"
            ];
            webauthheader.plugin.htransformation.Rules = [
              {
                Name = "Auth header rename";
                Header = "Remote-User";
                Value = "X-WebAuth-User";
                Type = "Rename";
              }
            ];
            default-headers.headers = {
              browserXssFilter = true;
              contentTypeNosniff = true;
              customFrameOptionsValue = "SAMEORIGIN";
              forceSTSHeader = true;
              frameDeny = true;
              stsIncludeSubdomains = true;
              stsPreload = true;
              stsSeconds = 15552000;
              customRequestHeaders.X-Forwarded-Proto = "https";
            };
            large-files.buffering.maxRequestBodyBytes = 53687091200;
            private-whitelist.ipAllowList.sourceRange = [
              "192.168.0.0/16"
              "172.16.0.0/12"
            ];
            proxmox.chain.middlewares = [
              "private-whitelist"
              "default-headers"
              "large-files"
            ];
            secured.chain.middlewares = [
              "private-whitelist"
              "default-headers"
            ];
            notifiarr.chain.middlewares = [
              "private-whitelist"
              "default-headers"
              "webauthheader"
            ];
            sslheader.headers.customRequestHeaders.X-Forwarded-Proto = "https";
            vaultwarden.headers.customRequestHeaders.X-Forwarded-Proto = "https";
          };
          routers = {
            calibre = {
              entryPoints = "https";
              middlewares = "default-headers";
              rule = "Host(`mybooks.niceastman.com`)";
              service = "calibre";
              tls = { };
            };
            dns = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`pdns.home.niceastman.com`)";
              service = "dns";
              tls = { };
            };
            files = {
              entryPoints = "https";
              middlewares = "default-headers";
              rule = "Host(`myshare.niceastman.com`)";
              service = "zipline";
              tls = { };
            };
            huntarr = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`huntarr.home.niceastman.com`)";
              service = "huntarr";
              tls = { };
            };
            jellyfin = {
              entryPoints = "https";
              middlewares = "default-headers";
              rule = "Host(`mymedia.niceastman.com`)";
              service = "jellyfin";
              tls = { };
            };
            lidarr = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`lidarr.home.niceastman.com`)";
              service = "lidarr";
              tls = { };
            };
            nas = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`nas.home.niceastman.com`)";
              service = "nas";
              tls = { };
            };
            prowlarr = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`prowlarr.home.niceastman.com`)";
              service = "prowlarr";
              tls = { };
            };
            pve = {
              entryPoints = "https";
              middlewares = "proxmox";
              rule = "Host(`pve.home.niceastman.com`)";
              service = "pve";
              tls = { };
            };
            pve2 = {
              entryPoints = "https";
              middlewares = "proxmox";
              rule = "Host(`pve2.home.niceastman.com`)";
              service = "pve2";
              tls = { };
            };
            radarr = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`radarr.home.niceastman.com`)";
              service = "radarr";
              tls = { };
            };
            rcm = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`rcm.home.niceastman.com`)";
              service = "rcm";
              tls = { };
            };
            rcm2 = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`rcm2.home.niceastman.com`)";
              service = "rcm2";
              tls = { };
            };
            sonarqube = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`sonarqube.home.niceastman.com`)";
              service = "sonarqube";
              tls = { };
            };
            sonarr = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`sonarr.home.niceastman.com`)";
              service = "sonarr";
              tls = { };
            };
            sonarr2 = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`sonarr2.home.niceastman.com`)";
              service = "sonarr2";
              tls = { };
            };
            sync = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`sync.home.niceastman.com`)";
              service = "syncthing";
              tls = { };
            };
            torrent = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`torrent.home.niceastman.com`)";
              service = "qbittorrent";
              tls = { };
            };
            torrent2 = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`torrent2.home.niceastman.com`)";
              service = "qbittorrent2";
              tls = { };
            };
            traefik = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`proxy.home.niceastman.com`)";
              service = "api@internal";
              tls = {
                certResolver = "cloudflare";
                domains = [
                  {
                    main = "niceastman.com";
                    sans = [
                      "*.niceastman.com"
                      "*.home.niceastman.com"
                    ];
                  }
                ];
              };
            };
            ups = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`ups.home.niceastman.com`)";
              service = "peanut";
              tls = { };
            };
            vaultwarden = {
              entryPoints = "https";
              middlewares = "vaultwarden";
              rule = "Host(`pass.niceastman.com`)";
              service = "vaultwarden";
              tls = { };
            };
          };
          services = {
            calibre.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.101:8083";
                }
              ];
              serversTransport = "insecure";
            };
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
            lidarr.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.113:8686";
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
            radarr.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.123:7878";
                }
              ];
              serversTransport = "insecure";
            };
            rcm.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "https://192.168.248.121";
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
            sonarqube.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.107:9000";
                }
              ];
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
  sops.secrets."traefik.env" = {
    format = "binary";
    group = config.systemd.services.traefik.serviceConfig.Group;
    owner = config.systemd.services.traefik.serviceConfig.User;
    sopsFile = "${flakeRoot}/.secrets/traefik.sops";
  };
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
}
