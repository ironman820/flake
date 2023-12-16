{ config, lib, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.servers.pdns-auth;
in
{
  options.ironman.servers.pdns-auth = {
    enable = mkBoolOpt false "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
    ironman = {
      sops = {
        enable = true;
        secrets = {
          # Used to set ENV variables for PowerDNS for example:
          # pdns: API_KEY=[SECRET KEY]
          pdns = {
            mode = "0400";
            owner = config.users.users.pdns.name;
            sopsFile = ./secrets/powerdns.yaml;
          };
          pdns-admin = {
            mode = "0400";
            owner = config.users.users.powerdnsadmin.name;
            sopsFile = ./secrets/powerdns.yaml;
          };
          pdns-salt = {
            mode = "0400";
            owner = config.users.users.powerdnsadmin.name;
            sopsFile = ./secrets/powerdns.yaml;
          };
        };
      };
      servers.postgresql = {
        authentication = mkOverride 20 ''
          local all pdns peer
        '';
        enable = true;
        script = [
          ''
            CREATE ROLE pdns WITH PASSWORD 'pdns' CREATEDB LOGIN;
            CREATE DATABASE pdns;
            GRANT ALL PRIVILEGES ON DATABASE pdns TO pdns;
            \c pdns pdns
            CREATE TABLE domains (
              id                    SERIAL PRIMARY KEY,
              name                  VARCHAR(255) NOT NULL,
              master                VARCHAR(128) DEFAULT NULL,
              last_check            INT DEFAULT NULL,
              type                  TEXT NOT NULL,
              notified_serial       BIGINT DEFAULT NULL,
              account               VARCHAR(40) DEFAULT NULL,
              options               TEXT DEFAULT NULL,
              catalog               TEXT DEFAULT NULL,
              CONSTRAINT c_lowercase_name CHECK (((name)::TEXT = LOWER((name)::TEXT)))
            );

            CREATE UNIQUE INDEX name_index ON domains(name);
            CREATE INDEX catalog_idx ON domains(catalog);


            CREATE TABLE records (
              id                    BIGSERIAL PRIMARY KEY,
              domain_id             INT DEFAULT NULL,
              name                  VARCHAR(255) DEFAULT NULL,
              type                  VARCHAR(10) DEFAULT NULL,
              content               VARCHAR(65535) DEFAULT NULL,
              ttl                   INT DEFAULT NULL,
              prio                  INT DEFAULT NULL,
              disabled              BOOL DEFAULT 'f',
              ordername             VARCHAR(255),
              auth                  BOOL DEFAULT 't',
              CONSTRAINT domain_exists
              FOREIGN KEY(domain_id) REFERENCES domains(id)
              ON DELETE CASCADE,
              CONSTRAINT c_lowercase_name CHECK (((name)::TEXT = LOWER((name)::TEXT)))
            );

            CREATE INDEX rec_name_index ON records(name);
            CREATE INDEX nametype_index ON records(name,type);
            CREATE INDEX domain_id ON records(domain_id);
            CREATE INDEX recordorder ON records (domain_id, ordername text_pattern_ops);


            CREATE TABLE supermasters (
              ip                    INET NOT NULL,
              nameserver            VARCHAR(255) NOT NULL,
              account               VARCHAR(40) NOT NULL,
              PRIMARY KEY(ip, nameserver)
            );


            CREATE TABLE comments (
              id                    SERIAL PRIMARY KEY,
              domain_id             INT NOT NULL,
              name                  VARCHAR(255) NOT NULL,
              type                  VARCHAR(10) NOT NULL,
              modified_at           INT NOT NULL,
              account               VARCHAR(40) DEFAULT NULL,
              comment               VARCHAR(65535) NOT NULL,
              CONSTRAINT domain_exists
              FOREIGN KEY(domain_id) REFERENCES domains(id)
              ON DELETE CASCADE,
              CONSTRAINT c_lowercase_name CHECK (((name)::TEXT = LOWER((name)::TEXT)))
            );

            CREATE INDEX comments_domain_id_idx ON comments (domain_id);
            CREATE INDEX comments_name_type_idx ON comments (name, type);
            CREATE INDEX comments_order_idx ON comments (domain_id, modified_at);


            CREATE TABLE domainmetadata (
              id                    SERIAL PRIMARY KEY,
              domain_id             INT REFERENCES domains(id) ON DELETE CASCADE,
              kind                  VARCHAR(32),
              content               TEXT
            );

            CREATE INDEX domainidmetaindex ON domainmetadata(domain_id);


            CREATE TABLE cryptokeys (
              id                    SERIAL PRIMARY KEY,
              domain_id             INT REFERENCES domains(id) ON DELETE CASCADE,
              flags                 INT NOT NULL,
              active                BOOL,
              published             BOOL DEFAULT TRUE,
              content               TEXT
            );

            CREATE INDEX domainidindex ON cryptokeys(domain_id);


            CREATE TABLE tsigkeys (
              id                    SERIAL PRIMARY KEY,
              name                  VARCHAR(255),
              algorithm             VARCHAR(50),
              secret                VARCHAR(255),
              CONSTRAINT c_lowercase_name CHECK (((name)::TEXT = LOWER((name)::TEXT)))
            );

            CREATE UNIQUE INDEX namealgoindex ON tsigkeys(name, algorithm);

            \c postgres postgres
            CREATE ROLE pda WITH PASSWORD 'pda' CREATEDB LOGIN;
            CREATE DATABASE pda;
            GRANT ALL PRIVILEGES ON DATABASE pda TO pda;
          ''
        ];
      };
    };
    networking.firewall = mkIf config.ironman.networking.firewall { allowedTCPPorts = [
      8000
    ]; };
    services = {
      powerdns = {
        enable = true;
        extraConfig = ''
          gpgsql-dbname=pdns
          gpgsql-host=localhost
          gpgsql-port=5432
          gpgsql-user=pdns
          gpgsql-password=pdns
          gpgsql-dnssec=yes
          launch=gpgsql
          local-address=127.0.0.1
          local-port=5300
          api=yes
          api-key=$API_KEY
        '';
        secretFile = config.sops.secrets.pdns.path;
      };
      powerdns-admin = {
        config = ''
          SQLALCHEMY_DATABASE_URI = 'postgresql://pda:pda@localhost/pda'
        '';
        enable = true;
        extraArgs = [ "-b" "0.0.0.0:8000" ];
        saltFile = config.sops.secrets.pdns-salt.path;
        secretKeyFile = config.sops.secrets.pdns-admin.path;
      };
    };
  };
}
