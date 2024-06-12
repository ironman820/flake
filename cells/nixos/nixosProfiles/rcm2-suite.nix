{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  c = v.rcm2;
  f = config.networking.firewall;
  l = nixpkgs.lib // mine.lib // builtins;
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
  t = l.types;
  v = config.vars;
in {
  options.vars.rcm2 = {
    service = l.mkBoolOpt false "Whether or not to create the django service";
    hostname = l.mkOpt t.str "rcm2.desk.niceastman.com" "The hostname for Caddy";
  };

  config = {
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
    networking.firewall = l.mkIf f.enable {
      allowedTCPPorts = [80];
    };
    services = {
      caddy = {
        enable = true;
        group = "users";
        virtualHosts."http://${c.hostname}:80" = {
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
        authentication = l.mkOverride 30 ''
          local all rcm2 peer
        '';
        enable = true;
        pgadmin = l.enabled;
        script = [
          ''
            CREATE ROLE rcm2 WITH PASSWORD 'rcm2' CREATEDB LOGIN;
            CREATE DATABASE rcm2;
            GRANT ALL PRIVILEGES ON DATABASE rcm2 TO rcm2;
          ''
        ];
      };
      redis = l.enabled;
    };
    systemd.services.django = {
      path = [python];
      bindsTo = ["caddy.service" "postgresql.service" "redis.service"];
      enable = c.service;
      script = "cd /data/rcm && ${python}/bin/python manage.py runserver";
      startLimitBurst = 5;
      startLimitIntervalSec = 10;
      wantedBy = ["multi-user.target"];
    };
    user.extraGroups = [config.users.groups.keys.name];
  };
}
