{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.suites.servers.rcm;
in {
  options.mine.suites.servers.rcm = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    mine = {
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
        php = {
          enable = true;
          ini = [
            "display_errors = On"
            "error_reporting = E_ALL"
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
      systemPackages = (with pkgs; [sonar-scanner-cli]) ++ (with pkgs.php74Packages; [phpcbf php-cs-fixer]);
      unixODBCDrivers = with pkgs.unixODBCDrivers; [msodbcsql17];
    };
    networking.firewall =
      mkIf config.mine.networking.firewall {allowedTCPPorts = [443];};
    users.users.nginx.home = "/home/${config.users.users.nginx.name}";
  };
}
