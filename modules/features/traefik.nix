{
  self,
  ...
}:
{
  flake.nixosModules.traefik =
    { config, lib, ... }:
    let
      inherit (lib)
        mapAttrs'
        mkEnableOption
        mkIf
        mkOption
        nameValuePair
        types
        ;
      cfg = config.ironman.traefik;
      srv = config.ironman.servers;
    in
    {
      options.ironman.traefik = {
        baseDomain = mkOption {
          default = "niceastman.com";
          description = "Base domain name to resolve hostnames with";
          type = types.str;
        };
        workServer = mkEnableOption "Is this a work server?";
      };
      config = {
        services.traefik = {
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
                traefik = {
                  entryPoints = "https";
                  middlewares = "secured";
                  rule = "Host(`proxy.home.niceastman.com`)";
                  service = "api@internal";
                  tls = {
                    certResolver = "cloudflare";
                    domains = [
                      {
                        main = cfg.baseDomain;
                        sans = [
                          "*.${cfg.baseDomain}"
                          "*.home.${cfg.baseDomain}"
                        ];
                      }
                    ];
                  };
                };
              }
              // mapAttrs' (
                _: value:
                nameValuePair value.service.name (
                  mkIf (value.service.enable && (cfg.workServer == value.workServer)) {
                    entryPoints = "https";
                    middlewares = if value.publicFacing then "default-headers" else "secured";
                    rule = "Host(`${value.service.name}.${cfg.baseDomain}`)";
                    service = value.service.name;
                    tls = { };
                  }
                )
              ) srv;
              services = mapAttrs' (
                _: value:
                nameValuePair value.service.name (
                  mkIf (value.service.enable && (cfg.workServer == value.workServer)) {
                    loadBalancer = {
                      passHostHeader = true;
                      servers = [
                        {
                          url = "http://${value.ip}:${toString value.service.port}";
                        }
                      ];
                      serversTransport = "insecure";
                    };
                  }
                )
              ) srv;
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
    };
}
