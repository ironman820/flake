{
  flake.nixosModules.slskd =
    { config, lib, ... }:
    let
      inherit (lib) mkOption;
      inherit (lib.types)
        listOf
        path
        str
        ;
      cfg = config.ironman.slsk;
      srv = config.ironman.servers.slsk;
      userName = config.ironman.user.name;
    in
    {
      options.ironman.slsk = {
        downloads = mkOption {
          description = "Location of downloads";
          type = path;
        };
        environmentFile = mkOption {
          description = "path to the environment file for slsk config";
          type = path;
        };
        incomplete = mkOption {
          description = "Location of incomplete downloads";
          type = path;
        };
        shares = mkOption {
          default = [ ];
          description = "List of shares for soulseek";
          type = listOf str;
        };
      };
      config = {
        services = {
          slskd = {
            inherit (cfg) environmentFile;
            enable = true;
            group = userName;
            settings = {
              directories = {
                inherit (cfg) downloads incomplete;
              };
              flags.force_share_scan = true;
              shares.directories = cfg.shares;
              soulseek.listen_port = srv.service.port;
            };
            user = userName;
          };
        };
      };
    };
}
