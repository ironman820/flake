{
  self,
  ...
}:
{
  flake.nixosModules.traefik-work = { config, pkgs, ... }: {
    microvm.vms.traefik-work = {
      inherit pkgs;
      config =
        let
          inherit (pkgs) lib;
          cfg = config.microvm.vms.traefik-work.config.config;
        in
        {
          imports = with self.nixosModules; [
            microvms-base
          ];
          home-manager.users.ironman = self.homeConfigurations.ironman-server;
          microvm = {
            interfaces = [
              {
                id = "vm-traefik";
                mac =
                  let
                    hash = builtins.hashString "sha256" "traefik-work";
                    octets = lib.genList (i: builtins.substring (i * 2) 2 hash) 5;
                  in
                  "02:${lib.concatStringsSep ":" octets}";
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
            vsock.cid = 5;
          };
          networking = {
            enableIPv6 = false;
            firewall.enable = false;
            hostName = "traefik-work";
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
                    rcm.loadBalancer = {
                      passHostHeader = true;
                      servers = [
                        {
                          url = "https://192.168.20.101:41443";
                        }
                      ];
                      serversTransport = "insecure";
                    };
                    rcm2.loadBalancer = {
                      passHostHeader = true;
                      servers = [
                        {
                          url = "http://192.168.20.107:8000";
                        }
                      ];
                      serversTransport = "insecure";
                    };
                  };
                  serversTransports.insecure.insecureSkipVerify = true;
                };
              };
              environmentFiles = [
                cfg.sops.secrets.traefik_env.path
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
                  filePath = "/home/ironman/traefik.log";
                  format = "json";
                  level = "INFO";
                };
              };
            };
            qemuGuest.enable = true;
          };
          sops.secrets.traefik_env = {
            group = cfg.systemd.services.traefik.serviceConfig.Group;
            owner = cfg.systemd.services.traefik.serviceConfig.User;
            sopsFile = "${self.outPath}/.secrets/traefik.yaml";
          };
          systemd.network = {
            enable = true;
            networks."20-lan" = {
              matchConfig.Type = "ether";
              networkConfig = {
                Address = [
                  "192.168.20.11/23"
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
