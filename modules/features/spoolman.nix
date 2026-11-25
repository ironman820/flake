{
  flake.nixosModules.spoolman = { config, lib, ... }: {
    options.ironman.spoolman = {
      corsOrigin = lib.mkOption {
        description = "External addresses that are pointed to this server";
        type = lib.types.str;
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
          SPOOLMAN_CORS_ORIGIN = config.ironman.spoolman.corsOrigin;
        };
      };
    };
  };
}
