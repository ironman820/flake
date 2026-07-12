{ flakeRoot, inputs, ... }:
{
  flake.nixosModules.rcm =
    {
      pkgs,
      config,
      ...
    }:
    let
      inherit (config.services.nginx) user;
      phpPkgs = import inputs.nixpkgs-php {
        inherit (pkgs.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    in
    {
      environment =
        let
          version-utils = import "${flakeRoot}/lib/version-utils.nix" { };
          inherit (version-utils) getVersionMajorMinor;
          pythonPackages = pkgs.python3.withPackages (
            ps: with ps; [
              ipykernel
              numpy
              pandas
              pyodbc
              python-dotenv
              requests
              sqlalchemy
            ]
          );
        in
        {
          systemPackages =
            (with phpPkgs; [
              (php74.buildEnv {
                extensions =
                  {
                    all,
                    enabled,
                  }:
                  enabled ++ (with all; [ sqlsrv ]);
              })
              php74Packages.psalm
              unixODBC
              (unixODBCDrivers.msodbcsql17.override { openssl = phpPkgs.openssl_1_1; })
            ])
            ++ (with pkgs; [
              basedpyright
              pythonPackages
            ]);
          unixODBCDrivers = with phpPkgs.unixODBCDrivers; [
            (msodbcsql17.override { openssl = phpPkgs.openssl_1_1; })
          ];
          variables = {
            LD_LIBRARY_PATH = "/run/opengl-driver/lib:${phpPkgs.unixODBC}/lib:${phpPkgs.unixODBCDrivers.msodbcsql17}/lib";
            PYTHONPATH = "${pythonPackages}/lib/python${getVersionMajorMinor pkgs.python3.version}/site-packages";
          };
        };
      networking.firewall.allowedTCPPorts = [ 443 ];
      services = {
        nginx = {
          enable = true;
          virtualHosts."rcm.desk.niceastman.com" = {
            default = true;
            listen = [
              {
                addr = "0.0.0.0";
                port = 443;
                ssl = true;
              }
            ];
            locations = {
              "/".extraConfig = ''
                index index.html index.php;
              '';
              "~ .php$".extraConfig = ''
                fastcgi_pass  unix:${config.services.phpfpm.pools.rcm.socket};
                fastcgi_index index.php;
              '';
            };
            onlySSL = true;
            root = "/data/rcm";
            sslCertificate = config.sops.secrets.rcm_cert.path;
            sslCertificateKey = config.sops.secrets.rcm_key.path;
          };
        };
        phpfpm = {
          pools.rcm = {
            inherit user;
            phpOptions = ''
              display_errors = On
              error_reporting = E_ALL
              max_execution_time = 120
              max_input_time = 60
              memory_limit = 768M
              post_max_size = 50M
              register_global = On
              short_open_tag = Off
            '';
            phpPackage = phpPkgs.php74.buildEnv {
              extensions =
                {
                  all,
                  enabled,
                }:
                enabled ++ (with all; [ sqlsrv ]);
            };
            settings = {
              pm = "dynamic";
              "listen.owner" = user;
              "pm.max_children" = 5;
              "pm.start_servers" = 2;
              "pm.min_spare_servers" = 1;
              "pm.max_spare_servers" = 3;
              "pm.max_requests" = 500;
            };
          };
        };
      };
      sops.secrets = {
        rcm_cert = {
          format = "binary";
          mode = "0400";
          owner = config.users.users.nginx.name;
          sopsFile = "${flakeRoot}/.secrets/rcm-cert.pem";
        };
        rcm_key = {
          format = "binary";
          mode = "0400";
          owner = config.users.users.nginx.name;
          sopsFile = "${flakeRoot}/.secrets/rcm-key.pem";
        };
      };
      users.users.${config.ironman.user.name}.extraGroups = [
        config.services.nginx.group
      ];
    };
}
