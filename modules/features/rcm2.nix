{ inputs, moduleWithSystem, ... }:
{
  flake.nixosModules.rcm2 = moduleWithSystem (
    perSystem@{ system, ... }:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.ironman) rcm2;
      inherit (lib) mkEnableOption mkIf mkOption;
      inherit (lib.types) nullOr str;
      phpPkgs = import inputs.nixpkgs-php {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      options.ironman.rcm2 = {
        enable = mkEnableOption "Enable RCM2 server";
        ip = mkOption {
          default = null;
          description = "IP address of the RCM2 server";
          type = nullOr str;
        };
        domain = mkOption {
          default = "home";
          description = "Subdomain of the server";
          type = str;
        };
      };
      config = {
        environment = mkIf rcm2.enable {
          systemPackages = with pkgs; [
            nodejs
            unixODBC
            (unixODBCDrivers.msodbcsql17.override { openssl = phpPkgs.openssl_1_1; })
          ];
          unixODBCDrivers = with pkgs.unixODBCDrivers; [
            (msodbcsql17.override { openssl = phpPkgs.openssl_1_1; })
          ];
        };
        services.traefik.dynamicConfigOptions.http = {
          routers.rcm2 = {
            entryPoints = "https";
            middlewares = "secured";
            rule = "Host(`rcm2.${rcm2.domain}.niceastman.com`)";
            service = "rcm2";
            tls = { };
          };
          services.rcm2.loadBalancer = {
            passHostHeader = true;
            servers = [
              {
                url = "http://${rcm2.ip}:8000";
              }
            ];
            serversTransport = "insecure";
          };
        };
        users.users.${config.ironman.user.name} = mkIf rcm2.enable {
          extraGroups = [
            config.services.nginx.group
          ];
        };
      };
    }
  );
}
