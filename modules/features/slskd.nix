{
  self,
  ...
}:
{
  flake.nixosModules.slskd = { config, lib, ... }: {
    options.ironman.slsk =
      let
        inherit (lib) mkEnableOption mkOption;
        inherit (lib.types)
          int
          listOf
          path
          str
          ;
      in
      {
        enable = mkEnableOption "Enable Soulseek server";
        downloads = mkOption {
          default = "/shares/data/downloads/music";
          description = "Location of downloads";
          type = path;
        };
        incomplete = mkOption {
          default = "/shares/data/downloads/incomplete";
          description = "Location of incomplete downloads";
          type = path;
        };
        ip = mkOption {
          default = "";
          description = "IP address of the soulseek server";
          type = str;
        };
        port = mkOption {
          default = 2234;
          description = "Port the server listens on for sharing";
          type = int;
        };
        shares = mkOption {
          default = [
            "/shares/data/music"
          ];
          description = "List of shares for soulseek";
          type = listOf str;
        };
      };
    config =
      let
        cfg = config.ironman;
        slsk = cfg.slsk;
      in
      {
        services = {
          slskd = {
            inherit (slsk) enable;
            domain = "slsk.home.niceastman.com";
            environmentFile = config.sops.secrets.slskd_env.path;
            group = cfg.user.name;
            settings = {
              directories = {
                inherit (slsk) downloads incomplete;
              };
              flags.force_share_scan = true;
              shares.directories = slsk.shares;
              soulseek.listen_port = slsk.port;
            };
            user = cfg.user.name;
          };
          traefik.dynamicConfigOptions.http = {
            routers.slsk = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`slsk.home.niceastman.com`)";
              service = "slsk";
              tls = { };
            };
            services.slsk.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://${slsk.ip}:5030";
                }
              ];
              serversTransport = "insecure";
            };
          };
        };
        sops.secrets.slskd_env = {
          sopsFile = "${self.outPath}/.secrets/soulseek.yaml";
          group = cfg.user.name;
        };
      };
  };
}
