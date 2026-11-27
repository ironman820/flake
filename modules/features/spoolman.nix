{
  flake.nixosModules.spoolman =
    { config, lib, ... }:
    let
      inherit (lib) mkForce mkOption;
      inherit (lib.types) str;
      cfg = config.ironman.spoolman;
    in
    {
      options.ironman.spoolman = {
        corsOrigin = mkOption {
          description = "External addresses that are pointed to this server";
          type = str;
        };
        dataDir = mkOption {
          default = "/var/lib/spoolman";
          description = "Data storage directory for the spoolman service";
          type = str;
        };
      };
      config = {
        ironman.postgres = {
          enable = true;
          dbName = "spoolman";
        };
        services.spoolman = {
          enable = true;
          listen = "0.0.0.0";
          environment = {
            SPOOLMAN_AUTOMATIC_BACKUP = "TRUE";
            SPOOLMAN_DB_TYPE = "postgres";
            SPOOLMAN_DB_HOST = "/var/run/postgresql";
            SPOOLMAN_DB_PORT = "5432";
            SPOOLMAN_DB_NAME = "spoolman";
            SPOOLMAN_DB_USERNAME = "spoolman";
            SPOOLMAN_DIR_DATA = cfg.dataDir;
            SPOOLMAN_CORS_ORIGIN = cfg.corsOrigin;
          };
        };
        systemd.services.spoolman.serviceConfig = {
          DynamicUser = mkForce false;
          User = config.ironman.servers.spoolman.user;
        };
      };
    };
}
