{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.suites.servers.rcm;
in
{
  options.ironman.suites.servers.rcm = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    ironman = {
      sops.secrets = {
        rcm_cert = {
          format = "binary";
          mode = "0400";
          owner = config.users.users.nginx.name;
          sopsFile = ./secrets/cert.pem;
        };
        rcm_key = {
          format = "binary";
          mode = "0400";
          owner = config.users.users.nginx.name;
          sopsFile = ./secrets/key.pem;
        };
      };
      servers = {
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
              "~ \.php$".extraConfig = ''
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
        php = {
          enable = true;
          ini = [
            "display_errors = On"
            "error_reporting = E_ALL"
            # "extension=${pkgs.php74Extensions.pdo_sqlsrv}/lib/php/extensions/pdo_sqlsrv.so"
            "extension=${pkgs.php74Extensions.sqlsrv}/lib/php/extensions/sqlsrv.so"
            "max_execution_time = 120"
            "max_input_time = 60"
            "memory_limit = 768M"
            "post_max_size = 50M"
            "register_global = On"
            "short_open_tag = Off"
          ];
        };
      };
    };
    environment = {
      systemPackages = with pkgs; [
        sonar-scanner-cli
      ];
      unixODBCDrivers = with pkgs.unixODBCDrivers; [
        msodbcsql17
      ];
    };
    networking.firewall.allowedTCPPorts = [
      443
    ];
    users.users.nginx.home = "/home/${config.users.users.nginx.name}";
  };
}
