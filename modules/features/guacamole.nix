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
      };
      config = {
        services = {
          guacamole-client = {
            inherit (guac) enable;
          };
          guacamole-server = {
            inherit (guac) enable;
          };
          traefik.dynamicConfigOptions.http = {
            routers.guacamole = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`rdp.desk.niceastman.com`)";
              service = "guacamole";
              tls = { };
            };
            services.guacamole.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://${guac.ip}";
                }
              ];
            };
          };
        };
      };
    };
}
