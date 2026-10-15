{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake = {
    nixosModules.lidarr = moduleWithSystem (
      perSystem@{ ... }:
      { config, lib, ... }:
      let
        inherit (lib) mkEnableOption mkOption types;
        cfg = config.ironman;
        ldr = cfg.lidarr;
      in
      {
        options.ironman.lidarr = {
          enable = mkEnableOption "Install lidarr server";
          ip = mkOption {
            default = null;
            description = "Lidarr IP address";
            type = types.nullOr types.str;
          };
        };
        config.services = {
          lidarr = {
            inherit (ldr) enable;
            group = cfg.user.name;
            user = cfg.user.name;
          };
          traefik.dynamicConfigOptions.http = {
            routers.lidarr = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`lidarr.home.niceastman.com`)";
              service = "lidarr";
              tls = { };
            };
            services.lidarr.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://${ldr.ip}:8686";
                }
              ];
              serversTransport = "insecure";
            };
          };
        };
      }
    );
    homeModules.lidarr = moduleWithSystem (
      perSystem@{ ... }:
      _: {
      }
    );
  };
}
