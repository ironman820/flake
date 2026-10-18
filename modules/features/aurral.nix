{
  self,
  ...
}:
{
  flake = {
    nixosModules.aurral =
      { config, lib, ... }:
      let
        inherit (lib) mkEnableOption mkOption types;
        cfg = config.ironman;
        aur = cfg.aurral;
      in
      {
        options.ironman.aurral = {
          enable = mkEnableOption "Install aurral server";
          ip = mkOption {
            default = null;
            description = "Aurral's IP address";
            type = types.nullOr types.str;
          };
        };
        config = {
          services = {
            aurral = {
              inherit (aur) enable;
              dataDir = "/shares/data/docker/aurral";
              environmentFile = config.sops.secrets.aurral_env.path;
              group = cfg.user.name;
              user = cfg.user.name;
            };
            traefik.dynamicConfigOptions.http = {
              routers.aurral = {
                entryPoints = "https";
                middlewares = "secured";
                rule = "Host(`aurral.home.niceastman.com`)";
                service = "aurral";
                tls = { };
              };
              services.aurral.loadBalancer = {
                passHostHeader = true;
                servers = [
                  {
                    url = "http://${aur.ip}:3001";
                  }
                ];
                serversTransport = "insecure";
              };
            };
          };
          sops.secrets.aurral_env = {
            sopsFile = "${self.outPath}/.secrets/aurral.yaml";
            owner = cfg.user.name;
            group = cfg.user.name;
          };
        };
      };
  };
}
