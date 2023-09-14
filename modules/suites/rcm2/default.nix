{ config, lib, options, pkgs, system, ... }:

with lib;
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
    django-extensions
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
      home.extraOptions = {
        home.shellAliases = {
          "cover" = "coverage run && coverage xml";
        };
        programs.git.extraConfig.safe.directory = "/data/rcm";
      };
      root-sops.secrets.rcm2-env = {
        format = "binary";
        mode = "0400";
        owner = config.ironman.user.name;
        sopsFile = ./secrets/rcm2.env.age;
      };
      servers = {
        caddy = {
          enable = true;
          virtualHosts."http://rcm2.desk.niceastman.com:80" = {
            extraConfig = ''
              root * /data/rcm
              @notStatic {
                not path /static/* /media/*
              }
              reverse_proxy @notStatic localhost:8000
              file_server
            '';
          };
        };
        # nginx.virtualHosts."rcm2.desk.niceastman.com" = {
        #   default = true;
        #   listen = [
        #     {
        #       addr = "0.0.0.0";
        #       port = 443;
        #       ssl = true;
        #     }
        #   ];
        #   locations = {
        #     "/".extraConfig = ''
        #       index index.html index.php;
        #     '';
        #     "~ \.php$".extraConfig = ''
        #       fastcgi_pass  unix:${config.services.phpfpm.pools.rcm.socket};
        #       fastcgi_index index.php;
        #     '';
        #   };
        #   onlySSL = true;
        #   root = "/data/rcm";
        #   sslCertificate = config.sops.secrets.rcm_cert.path;
        #   sslCertificateKey = config.sops.secrets.rcm_key.path;
        # };
        postgresql = {
          authentication = mkOverride 30 ''
            local all rcm2 peer
          '';
          enable = true;
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
      # suites.servers.rcm = enabled;
      # user.extraGroups = [
      #   "caddy"
      # ];
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
  };
}
