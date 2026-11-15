{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake = {
    nixosModules.bazarr = moduleWithSystem (
      perSystem@{ ... }:
      { config, lib, ... }:
      let
        inherit (lib) mkEnableOption mkOption;
        inherit (lib.types) nullOr str;
        cfg = config.ironman;
        bzr = cfg.bazarr;
      in
      {
        options.ironman.bazarr = {
          enable = mkEnableOption "Install the Bazarr server";
          ip = mkOption {
            default = null;
            description = "Bazarr IP address";
            type = nullOr str;
          };
        };
        config.services = {
          bazarr = {
            inherit (bzr) enable;
            group = cfg.user.name;
            user = cfg.user.name;
          };
          traefik.dynamicConfigOptions.http = {
            routers.bazarr = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`bazarr.home.niceastman.com`)";
              service = "bazarr";
              tls = { };
            };
            services.bazarr.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://${bzr.ip}:6767";
                }
              ];
              serversTransport = "insecure";
            };
          };
        };
      }
    );
  };
}
