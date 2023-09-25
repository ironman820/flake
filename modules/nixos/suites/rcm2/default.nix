{ config, lib, options, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.suites.servers.rcm2;
  my-python-packages = ps: with ps; [
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
    pytz
    redis
    sqlalchemy
  ];
  python = pkgs.python310.withPackages my-python-packages;
in
{
  options.ironman.suites.servers.rcm2 = with types; {
    enable = mkBoolOpt false "Enable the suite";
  };

  config = mkIf cfg.enable {
    ironman = {
      sops.secrets.rcm2-env = {
        format = "binary";
        group = config.users.groups.users.name;
        mode = "0400";
        owner = config.ironman.user.name;
        path = "/data/rcm/.env";
        restartUnits = [
          "django.service"
        ];
        sopsFile = ./secrets/rcm2.env.age;
      };
      servers = {
        caddy = {
          enable = true;
          virtualHosts."http://rcm2.desk.niceastman.com:80" = {
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
      user.extraGroups = [
        config.users.groups.keys.name
      ];
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
      unixODBCDrivers = with pkgs.unixODBCDrivers; [
        msodbcsql17
      ];
      shellInit = ''
        set -a
        source ${config.sops.secrets.rcm2-env.path}
        set +a
        rm -f /data/rcm/.python
        ln -sf ${python} /data/rcm/.python
      '';
      systemPackages = (with pkgs; [
        sonar-scanner-cli
        unixODBC
      ]) ++ ([ python ]);
    };
    networking.firewall.allowedTCPPorts = [
      80
    ];
    services.caddy.group = "users";
    systemd.services.django = {
      aliases = [
        "django.service"
      ];
      path = [
        python
      ];
      requires = [
        "caddy.service"
        "postgresql.service"
        "redis.service"
      ];
      script = "cd /data/rcm && ${python}/bin/python manage.py runserver";
      startLimitBurst = 5;
      startLimitIntervalSec = 10;
    };
  };
}
