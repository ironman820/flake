{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.servers.postgresql;
in
{
  options.ironman.servers.postgresql = with types; {
    authentication = mkOpt str "" "Authentication options";
    dbs = mkOpt (listOf str) [ ] "Databases to ensure are added to the server";
    enable = mkBoolOpt false "Enable or disable postgresql service";
    pgadmin = {
      enable = mkBoolOpt false "Enable PGAdmin";
      email = mkOpt str config.ironman.user.email "Initial admin Email";
      firewall = mkBoolOpt true "Open the firewall?";
      settings = mkOpt attrs
        {
          "ALLOWED_HOSTS" = [
            "192.168.0.0/16"
          ];
          "CONFIG_DATABASE_URI" = "postgresql://${config.ironman.user.name}:${config.ironman.user.name}@localhost/${config.ironman.user.name}";
        } "Settings for PGAdmin";
    };
    script = mkOpt (listOf str) "" "Postgres Initial startup script.";
    users = mkOpt (listOf attrs) [ ] "ensureUsers variables";
  };

  config = mkIf cfg.enable {
    ironman = {
      root-sops = mkIf cfg.pgadmin.enable {
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
          local all ${config.ironman.user.name} peer
          local all all trust
        '';
        script = [
          ''
            CREATE ROLE ${config.ironman.user.name} WITH PASSWORD '${config.ironman.user.name}' SUPERUSER CREATEROLE CREATEDB REPLICATION BYPASSRLS LOGIN;
            CREATE DATABASE ironman;
            GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${config.ironman.user.name};
            GRANT ALL PRIVILEGES ON DATABASE postgres TO ${config.ironman.user.name};
            GRANT ALL PRIVILEGES ON DATABASE ${config.ironman.user.name} TO ${config.ironman.user.name};
          ''
        ];
      };
    };
    services = {
      pgadmin = {
        enable = config.ironman.servers.postgresql.pgadmin.enable;
        initialEmail = mkAliasDefinitions options.ironman.servers.postgresql.pgadmin.email;
        initialPasswordFile = config.sops.secrets.pg_pass.path;
        openFirewall = mkAliasDefinitions options.ironman.servers.postgresql.pgadmin.firewall;
        settings = mkAliasDefinitions options.ironman.servers.postgresql.pgadmin.settings;
      };
      postgresql = {
        authentication = mkAliasDefinitions options.ironman.servers.postgresql.authentication;
        enable = true;
        ensureDatabases = mkAliasDefinitions options.ironman.servers.postgresql.dbs;
        ensureUsers = mkAliasDefinitions options.ironman.servers.postgresql.users;
        initialScript = pkgs.writeText "init-script" (strings.concatStringsSep "\n" config.ironman.servers.postgresql.script);
      };
    };
    systemd.services.pgadmin.serviceConfig.SupplimentaryGroups = [ config.users.groups.keys.name ];
  };
}
