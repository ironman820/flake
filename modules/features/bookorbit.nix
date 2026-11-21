{
  flake.nixosModules.bookorbit =
    { config, lib, ... }:
    let
      inherit (lib) mkEnableOption mkOption;
      inherit (lib.types) nullOr str;
      bo = config.ironman.bookorbit;
      userName = config.ironman.user.name;
    in
    {
      options.ironman.bookorbit = {
        enable = mkEnableOption "Enable BookOrbit server.";
        ip = mkOption {
          default = null;
          description = "BookOrbit IP address";
          type = nullOr str;
        };
        domain = mkOption {
          default = "mybooks";
          description = "Subdomain of the server";
          type = str;
        };
      };
      config = {
        services = {
          bookorbit = {
            inherit (bo) enable;
            createDatabaseLocally = true;
            environmentFile = config.sops.secrets.bookorbit_env.path;
            group = userName;
            user = userName;
          };
          postgresql = {
            inherit (bo) enable;
            authentication = lib.mkForce ''
              local all all ident map=bookorbit
            '';
            ensureDatabases = [
              "bookorbit"
            ];
            ensureUsers = [
              {
                ensureDBOwnership = true;
                name = "bookorbit";
              }
            ];
            identMap = ''
              bookorbit ${userName} bookorbit
              bookorbit postgres postgres
            '';
          };
          traefik.dynamicConfigOptions.http = {
            routers.bookorbit = {
              entryPoints = "https";
              middlewares = "default-headers";
              rule = "Host(`${bo.domain}.niceastman.com`)";
              service = "bookorbit";
              tls = { };
            };
            services.bookorbit.loadBalancer = {
              passHostHeader = true;
              servers = [
                {
                  url = "http://${bo.ip}:3000";
                }
              ];
              serversTransport = "insecure";
            };
          };
        };
      };
    };
}
