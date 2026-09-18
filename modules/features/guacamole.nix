{
  flake.nixosModules.guacamole =
    { config, lib, ... }:
    let
      inherit (lib) mkEnableOption mkOption types;
      cfg = config.ironman;
      guac = cfg.guacamole;
    in
    {
      options.ironman.guacamole = {
        enable = mkEnableOption "Install Guacamole server and client";
        ip = mkOption {
          default = null;
          description = "Guacamole server's IP address";
          type = types.nullOr types.str;
        };
        userMappingXml = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/path/to/user-mapping.xml";
          description = ''
            Configuration file that correspond to `user-mapping.xml`.
          '';
        };
      };
      config = {
        services = {
          guacamole-client = {
            inherit (guac) enable userMappingXml;
            settings = {
              allowed-languages = "en";
              case-sensitivity = "disabled";
            };
          };
          guacamole-server = {
            inherit (guac) enable;
          };
          traefik.dynamicConfigOptions.http = {
            routers.guacamole = {
              entryPoints = "https";
              middlewares = "guacamole";
              rule = "Host(`rdp.desk.niceastman.com`)";
              service = "guacamole";
              tls = { };
            };
            services.guacamole.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://${guac.ip}:8080";
                }
              ];
            };
          };
        };
      };
    };
}
