{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake.nixosModules.rcm = moduleWithSystem (
    perSystem@{ system, ... }:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.ironman) rcm;
      inherit (lib) mkEnableOption mkIf mkOption;
      inherit (lib.types) nullOr str;
      phpPackage = phpPkgs.php74.buildEnv {
        extensions =
          {
            all,
            enabled,
          }:
          enabled
          ++ (with all; [
            snmp
            sqlsrv
          ]);
      };
      phpPkgs = import inputs.nixpkgs-php {
        inherit system;
        config.allowUnfree = true;
      };
      sps = config.sops.secrets;
      user = config.ironman.user.name;
    in
    {
      options.ironman.rcm = {
        enable = mkEnableOption "Enable RCM installation";
        domain = mkOption {
          default = "home";
          description = "Subdomain where server sits";
          type = str;
        };
        ip = mkOption {
          default = null;
          description = "IP address of the RCM server";
          type = nullOr str;
        };
      };
      config = {
        environment = mkIf rcm.enable {
          systemPackages = with phpPkgs; [
            phpPackage
            pkgs.phpactor
            pkgs.pretty-php
            unixODBC
            (unixODBCDrivers.msodbcsql17.override { openssl = phpPkgs.openssl_1_1; })
          ];
          unixODBCDrivers = with phpPkgs.unixODBCDrivers; [
            (msodbcsql17.override { openssl = phpPkgs.openssl_1_1; })
          ];
          variables = {
            LD_LIBRARY_PATH = "/run/opengl-driver/lib:${phpPkgs.unixODBC}/lib:${phpPkgs.unixODBCDrivers.msodbcsql17}/lib";
          };
        };
        services = {
          nginx = mkIf rcm.enable {
            inherit user;
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
              sslCertificate = sps.rcm_cert.path;
              sslCertificateKey = sps.rcm_key.path;
            };
          };
          phpfpm = mkIf rcm.enable {
            pools.rcm = {
              inherit phpPackage user;
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
            phpOptions = ''
              date.timezone = "America/Chicago"
            '';
          };
          traefik.dynamicConfigOptions.http = {
            routers.rcm = {
              entryPoints = "https";
              middlewares = "secured";
              rule = "Host(`rcm.${rcm.domain}.niceastman.com`)";
              service = "rcm";
              tls = { };
            };
            services.rcm.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "https://${rcm.ip}:443";
                }
              ];
              serversTransport = "insecure";
            };
          };
        };
        sops.secrets = mkIf rcm.enable (
          let
            format = "binary";
            mode = "0400";
            owner = user;
          in
          {
            rcm_cert = {
              inherit format mode owner;
              sopsFile = "${self.outPath}/.secrets/rcm-cert.pem";
            };
            rcm_key = {
              inherit format mode owner;
              sopsFile = "${self.outPath}/.secrets/rcm-key.pem";
            };
          }
        );
        users.users.${user} = mkIf rcm.enable {
          extraGroups = [
            config.services.nginx.group
          ];
        };
      };
    }
  );
}
