{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOverride;
  inherit (lib.mine) enabled mkBoolOpt mkOpt;
  inherit (lib.types) str;

  cfg = config.mine.suites.server.rcm2;
  my-python-packages = ps:
    with ps; [
      asgiref
      black
      channels
      channels-redis
      coverage
      daphne
      django
      django-environ
      django-extensions
      faker
      flake8
      numpy
      pandas
      pip
      pillow
      psycopg2
      pyodbc
      pytest
      pytest-django
      python-dotenv
      pytz
      redis
      sqlalchemy
    ];
  python = pkgs.python3.withPackages my-python-packages;
in {
  options.mine.suites.server.rcm2 = {
    enable = mkEnableOption "Enable the suite";
    service = mkBoolOpt false "Whether or not to create the django service";
    hostname = mkOpt str "rcm2.desk.niceastman.com" "The hostname for Caddy";
  };

  config = mkIf cfg.enable {
    mine = {
      servers = {
        caddy = {
          enable = true;
          virtualHosts."http://${cfg.hostname}:80" = {
            extraConfig = ''
              root * /data/rcm
              @notStatic {
                not path /static/* /media/* /htmlcov/*
              }
              reverse_proxy @notStatic localhost:8000
              file_server
            '';
          };
        };
        postgresql = {
          authentication = mkOverride 30 ''
            local all rcm2 peer
          '';
          enable = true;
          pgadmin = enabled;
          script = [
            ''
              CREATE ROLE rcm2 WITH PASSWORD 'rcm2' CREATEDB LOGIN;
              CREATE DATABASE rcm2;
              GRANT ALL PRIVILEGES ON DATABASE rcm2 TO rcm2;
            ''
          ];
        };
        redis = enabled;
      };
      user.extraGroups = [config.users.groups.keys.name];
    };
    environment = {
      etc."ssl/openssl.cnf".text = ''
        openssl_conf = default_conf

        [default_conf]
        ssl_conf = ssl_sect

        [ssl_sect]
        system_default = system_default_sect

        [system_default_sect]
        MinProtocol = TLSv1.0
        CipherString = DEFAULT@SECLEVEL=1
      '';
      shellAliases = {
        cover = "coverage run && coverage xml && coverage html";
      };
      systemPackages =
        (with pkgs; [sonar-scanner-cli unixODBC])
        ++ [python];
      unixODBCDrivers = with pkgs.unixODBCDrivers; [msodbcsql17];
    };
    networking.firewall = mkIf config.mine.networking.basic.firewall {
      allowedTCPPorts = [80];
    };
    services.caddy.group = "users";
    systemd.services.django = {
      path = [python];
      bindsTo = ["caddy.service" "postgresql.service" "redis.service"];
      enable = cfg.service;
      script = "cd /data/rcm && ${python}/bin/python manage.py runserver";
      startLimitBurst = 5;
      startLimitIntervalSec = 10;
      wantedBy = ["multi-user.target"];
    };
  };
}
