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
    3128
    8080
  ];
  nix.settings.cores = 1;
  security.sudo.wheelNeedsPassword = false;
  services = {
    openssh.settings.PermitRootLogin = "no";
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
            dns = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`pdns.desk.niceastman.com`)";
              service = "dns";
              tls = { };
            };
            mail = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`mail.desk.niceastman.com`)";
              service = "mailhog";
              tls = { };
            };
            pve = {
              entryPoints = "https";
              middlewares = "proxmox";
              rule = "Host(`pve.desk.niceastman.com`)";
              service = "pve";
              tls = { };
            };
            rcm = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`rcm.desk.niceastman.com`)";
              service = "rcm";
              tls = { };
            };
            rcm2 = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`rcm2.desk.niceastman.com`)";
              service = "rcm2";
              tls = { };
            };
            traefik = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`proxy.desk.niceastman.com`)";
              service = "api@internal";
              tls = {
                certResolver = "cloudflare";
                domains = [
                  {
                    sans = [
                      "*.desk.niceastman.com"
                    ];
                  }
                ];
              };
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
            mailhog.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.21.111:8025";
                }
              ];
              serversTransport = "insecure";
            };
            pve.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "https://192.168.21.50:8006";
                }
              ];
              serverstransport = "insecure";
            };
            rcm.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "https://192.168.21.103";
                }
              ];
              serversTransport = "insecure";
            };
            rcm2.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://192.168.21.104:8000";
                }
              ];
              serversTransport = "insecure";
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
