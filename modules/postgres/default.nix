{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf mkOverride strings;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.types) str listOf attrs;
  cfg = config.mine.servers.postgresql;
in {
  options.mine.servers.postgresql = {
    authentication = mkOpt str "" "Authentication options";
    dbs = mkOpt (listOf str) [] "Databases to ensure are added to the server";
    enable = mkEnableOption "Enable or disable postgresql service";
    pgadmin = {
      enable = mkBoolOpt false "Enable PGAdmin";
      email = mkOpt str config.mine.user.email "Initial admin Email";
      firewall = mkBoolOpt true "Open the firewall?";
      settings =
        mkOpt attrs
        {
          "ALLOWED_HOSTS" = [
          ];
          "CONFIG_DATABASE_URI" = "postgresql://${config.mine.user.name}:${config.mine.user.name}@localhost/${config.mine.user.name}";
        } "Settings for PGAdmin";
    };
    script = mkOpt (listOf str) "" "Postgres Initial startup script.";
    users = mkOpt (listOf attrs) [] "ensureUsers variables";
  };

  config = mkIf cfg.enable {
    mine = {
      sops = mkIf cfg.pgadmin.enable {
        enable = true;
        secrets = {
          pg_pass = {
            mode = "0400";
            # neededForUsers = true;
            owner = config.users.users.pgadmin.name;
            sopsFile = ./secrets/postgres.yaml;
          };
        };
      };
      servers.postgresql = {
        authentication = mkOverride 10 ''
          local all ${config.mine.user.name} peer
          local all all trust
        '';
        script = [
          ''
            CREATE ROLE ${config.mine.user.name} WITH PASSWORD '${config.mine.user.name}' SUPERUSER CREATEROLE CREATEDB REPLICATION BYPASSRLS LOGIN;
            CREATE DATABASE mine;
            GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${config.mine.user.name};
            GRANT ALL PRIVILEGES ON DATABASE postgres TO ${config.mine.user.name};
            GRANT ALL PRIVILEGES ON DATABASE ${config.mine.user.name} TO ${config.mine.user.name};
          ''
        ];
      };
    };
    services = {
      pgadmin = mkIf cfg.pgadmin.enable {
        enable = true;
        initialEmail = mkAliasDefinitions options.mine.servers.postgresql.pgadmin.email;
        initialPasswordFile = config.sops.secrets.pg_pass.path;
        openFirewall = mkAliasDefinitions options.mine.servers.postgresql.pgadmin.firewall;
        settings = mkAliasDefinitions options.mine.servers.postgresql.pgadmin.settings;
      };
      postgresql = {
        authentication = mkAliasDefinitions options.mine.servers.postgresql.authentication;
        enable = true;
        ensureDatabases = mkAliasDefinitions options.mine.servers.postgresql.dbs;
        ensureUsers = mkAliasDefinitions options.mine.servers.postgresql.users;
        initialScript = pkgs.writeText "init-script" (strings.concatStringsSep "\n" config.mine.servers.postgresql.script);
        package = pkgs.postgresql_14;
      };
    };
    users.users.pgadmin = mkIf cfg.pgadmin.enable {
      extraGroups = [config.users.groups.keys.name];
    };
  };
}
