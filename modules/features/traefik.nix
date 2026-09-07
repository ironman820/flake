{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake = {
    nixosModules.traefik = moduleWithSystem (
      perSystem@{ ... }: { config, lib, ... }: {
        options.ironman.traefik = {
          enable = lib.mkEnableOption "Enable Traefik Server";
        };
        config =
          let
            cfg = config.ironman.traefik;
          in
          {
            services.traefik = {
              inherit (cfg) enable;
              dynamicConfigOptions = {
                http = {
                  middlewares = {
                    # guac-prefix.addprefix.prefix = "/guacamole";
                    # guacamole.chain.middlewares = [
                    #   "guac-prefix"
                    #   "private-whitelist"
                    #   "default-headers"
                    # ];
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
                  routers.traefik = {
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
                };
              };
              environmentFiles = [
                config.sops.secrets."traefik.env".path
              ];
            };
            sops.secrets."traefik.env" = {
              format = "binary";
              group = config.systemd.services.traefik.serviceConfig.Group;
              owner = config.systemd.services.traefik.serviceConfig.User;
              sopsFile = "${self.outPath}/.secrets/traefik.sops";
            };
          };
      }
    );
    homeModules.traefik = moduleWithSystem (
      perSystem@{ ... }:
      _: {
      }
    );
  };
}
