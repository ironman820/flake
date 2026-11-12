{
  flake.nixosModules.radarr =
    { config, lib, ... }:
    let
      inherit (lib) mkEnableOption mkOption types;
      cfg = config.ironman;
      rdr = cfg.radarr;
    in
    {
      options.ironman.radarr = {
        enable = mkEnableOption "Install radarr server";
        ip = mkOption {
          default = null;
          description = "Radarr IP address";
          type = types.nullOr types.str;
        };
      };
      config.services = {
        radarr = {
          inherit (rdr) enable;
          dataDir = "/var/lib/radarr/";
          group = cfg.user.name;
          user = cfg.user.name;
        };
        traefik.dynamicConfigOptions.http = {
          routers.radarr = {
            entryPoints = "https";
            middlewares = "secured";
            rule = "Host(`radarr.home.niceastman.com`)";
            service = "radarr";
            tls = { };
          };
          services.radarr.loadBalancer = {
            passHostHeader = true;
            servers = [
              {
                url = "http://${rdr.ip}:7878";
              }
            ];
            serversTransport = "insecure";
          };
        };
      };
    };
}
