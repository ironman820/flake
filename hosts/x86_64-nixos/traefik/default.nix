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
    22
    80
    443
    2222
    3128
    8080
  ];
  nix.settings.cores = 1;
  security.sudo.wheelNeedsPassword = false;
  services = {
    openssh.ports = [
      2222
    ];
    qemuGuest.enable = true;
    traefik = {
      enable = true;
      dynamicConfigOptions = {
        http = {
          middlewares = {
            authentik.forwardAuth = {
              address = "http://192.168.248.38:9000/outpost.goauthentik.io/auth/traefik";
              trustForwardHeader = true;
              authResponseHeaders = [
                "X-authentik-username"
                "X-authentik-groups"
                "X-authentik-entitlements"
                "X-authentik-email"
                "X-authentik-name"
                "X-authentik-uid"
                "X-authentik-jwt"
                "X-authentik-meta-jwks"
                "X-authentik-meta-outpost"
                "X-authentik-meta-provider"
                "X-authentik-meta-app"
                "X-authentik-meta-version"
                "authorization"
              ];
            };
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
          };
          routers = {
            authentik = {
              entryPoints = "https";
              middlewares = "default-headers";
              rule = "Host(`auth.niceastman.com`)";
              service = "authentik";
              tls = { };
            };
            dns = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`pdns.home.niceastman.com`)";
              service = "dns";
              tls = { };
            };
            fflows = {
                entryPoints = "https";
                middlewares = "secured";
                rule = "Host(`fflows.home.niceastman.com`)";
                service = "fflows";
                tls = {};
              };
            git = {
              entryPoints = "https";
              middlewares = "default-headers";
              rule = "Host(`git.niceastman.com`)";
              service = "git";
              tls = { };
            };
            guacamole = {
              entryPoints = "https";
              middlewares = "guacamole";
              rule = "Host(`rdp.home.niceastman.com`)";
              service = "guacamole";
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
            notifiarr = {
              entryPoints = "https";
              middlewares = "notifiarr";
              rule = "Host(`notifiarr.home.niceastman.com`)";
              service = "notifiarr";
              tls = { };
            };
            omv = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`omv.home.niceastman.com`)";
              service = "omv";
              tls = { };
            };
            prowlarr = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`prowlarr.home.niceastman.com`)";
              service = "prowlarr";
              tls = { };
            };
            proxmox = {
              entryPoints = "https";
              middlewares = "proxmox";
              rule = "Host(`pve-old.home.niceastman.com`)";
              service = "proxmox";
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
              middlewares = "authentik";
              rule = "Host(`radarr.home.niceastman.com`)";
              service = "radarr";
              tls = { };
            };
            rcm2 = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`rcm2.home.niceastman.com`)";
              service = "rcm2";
              tls = { };
            };
            sonarr = {
              entryPoints = "https";
              middlewares = "authentik";
              rule = "Host(`sonarr.home.niceastman.com`)";
              service = "sonarr";
              tls = { };
            };
            sonarr2 = {
              entryPoints = "https";
              middlewares = "authentik";
              rule = "Host(`sonarr2.home.niceastman.com`)";
              service = "sonarr2";
              tls = { };
            };
            sync = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`sync.home.niceastman.com`)";
              service = "resilio";
              tls = { };
            };
            tdarr = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`tdarr.home.niceastman.com`)";
              service = "tdarr";
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
            vaultwarden = {
              entryPoints = "https";
              middlewares = "default-headers";
              rule = "Host(`pass.niceastman.com`)";
              service = "vaultwarden";
              tls = { };
            };
          };
          services = {
            authentik.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "https://192.168.248.38:9443";
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
            fflows.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.117:19200";
                }
              ];
              serversTransport = "insecure";
            };
            git.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.13:3000";
                }
              ];
              serversTransport = "insecure";
            };
            guacamole.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.35:8080";
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
                  url = "https://192.168.254.5:5001";
                }
              ];
              serversTransport = "insecure";
            };
            notifiarr.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.108:5454";
                }
              ];
              serversTransport = "insecure";
            };
            omv.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.5";
                }
              ];
              serversTransport = "insecure";
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
            proxmox.loadBalancer = {
              passhostheader = true;
              servers = [
                {
                  url = "https://192.168.248.3:8006";
                }
              ];
              serverstransport = "insecure";
            };
            pve.loadBalancer = {
              passhostheader = true;
              servers = [
                {
                  url = "https://192.168.250.50:8006";
                }
              ];
              serverstransport = "insecure";
            };
            pve2.loadBalancer = {
              passhostheader = true;
              servers = [
                {
                  url = "https://192.168.250.51:8006";
                }
              ];
              serverstransport = "insecure";
            };
            qbittorrent.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.16:8080";
                }
              ];
              serversTransport = "insecure";
            };
            qbittorrent2.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.16:8081";
                }
              ];
              serversTransport = "insecure";
            };
            radarr.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.107:7878";
                }
              ];
              serversTransport = "insecure";
            };
            resilio.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "https://192.168.254.5:28888";
                }
              ];
              serversTransport = "insecure";
            };
            rcm2.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.119:8000";
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
              serversTransport = "insecure";
            };
            sonarr2.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.110:8989";
                }
              ];
              serversTransport = "insecure";
            };
            tdarr.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.42:8265";
                }
              ];
              serversTransport = "insecure";
            };
            vaultwarden.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.248.103:8000";
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
