{
  self,
  ...
}:
{
  flake = {
    nixosModules.navidrome =
      { config, lib, ... }:
      let
        inherit (lib) mkEnableOption mkOption types;
        cfg = config.ironman;
        navi = cfg.navidrome;
      in
      {
        options.ironman.navidrome = {
          enable = mkEnableOption "Install navidrome server";
          ip = mkOption {
            default = null;
            description = "Navidrome's IP address";
            type = types.nullOr types.str;
          };
        };
        config = {
          services = {
            navidrome = {
              inherit (navi) enable;
              environmentFile = config.sops.secrets.navidrome_env.path;
              group = cfg.user.name;
              settings = {
                Address = "0.0.0.0";
                DataFolder = "/shares/data/docker/navidrome";
                DefaultUIVolume = "75";
                EnableInsightsCollector = false;
                EnforceNonRootUser = true;
                MusicFolder = "/shares/data/music";
              };
              user = cfg.user.name;
            };
            traefik.dynamicConfigOptions.http = {
              routers.navidrome = {
                entryPoints = "https";
                middlewares = "secured";
                rule = "Host(`mymusic.niceastman.com`)";
                service = "navidrome";
                tls = { };
              };
              services.navidrome.loadBalancer = {
                passHostHeader = true;
                servers = [
                  {
                    url = "http://${navi.ip}:4533";
                  }
                ];
                serversTransport = "insecure";
              };
            };
          };
          sops.secrets.navidrome_env = {
            sopsFile = "${self.outPath}/.secrets/navidrome.yaml";
            owner = cfg.user.name;
            group = cfg.user.name;
          };
        };
      };
  };
}
