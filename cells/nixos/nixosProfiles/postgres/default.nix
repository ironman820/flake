{
  cell,
  config,
  inputs,
  options,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  c = v.postgresql;
  l = nixpkgs.lib // mine.lib // builtins;
  ls = l.strings;
  o = options.vars.postgresql;
  s = config.sops.secrets;
  t = l.types;
  v = config.vars;
in {
  options.vars.postgresql = {
    authentication = l.mkOpt t.str "" "Authentication options";
    dbs = l.mkOpt (t.listOf t.str) [] "Databases to ensure are added to the server";
    pgadmin = {
      enable = l.mkEnableOption "Enable PGAdmin";
      email = l.mkOpt t.str v.email "Initial admin Email";
      firewall = l.mkBoolOpt true "Open the firewall?";
      settings =
        l.mkOpt t.attrs
        {
          "ALLOWED_HOSTS" = [
          ];
          "CONFIG_DATABASE_URI" = "postgresql://${v.username}:${v.username}@localhost/${v.username}";
        } "Settings for PGAdmin";
    };
    script = l.mkOpt (t.listOf t.str) "" "Postgres Initial startup script.";
    users = l.mkOpt (t.listOf t.attrs) [] "ensureUsers variables";
  };

  config = {
    mine = {
      sops = l.mkIf c.pgadmin.enable {
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
        authentication = l.mkOverride 10 ''
          local all ${v.username} peer
          local all all trust
        '';
        script = [
          ''
            CREATE ROLE ${v.username} WITH PASSWORD '${v.username}' SUPERUSER CREATEROLE CREATEDB REPLICATION BYPASSRLS LOGIN;
            CREATE DATABASE mine;
            GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${v.username};
            GRANT ALL PRIVILEGES ON DATABASE postgres TO ${v.username};
            GRANT ALL PRIVILEGES ON DATABASE ${v.username} TO ${v.username};
          ''
        ];
      };
    };
    services = {
      pgadmin = l.mkIf c.pgadmin.enable {
        enable = true;
        initialEmail = l.mkAliasDefinitions o.pgadmin.email;
        initialPasswordFile = s.pg_pass.path;
        openFirewall = l.mkAliasDefinitions o.pgadmin.firewall;
        settings = l.mkAliasDefinitions o.pgadmin.settings;
      };
      postgresql = {
        authentication = l.mkAliasDefinitions o.authentication;
        enable = true;
        ensureDatabases = l.mkAliasDefinitions o.dbs;
        ensureUsers = l.mkAliasDefinitions o.users;
        initialScript = pkgs.writeText "init-script" (ls.concatStringsSep "\n" c.script);
        package = pkgs.postgresql_14;
      };
    };
    users.users.pgadmin = l.mkIf c.pgadmin.enable {
      extraGroups = [config.users.groups.keys.name];
    };
  };
}
