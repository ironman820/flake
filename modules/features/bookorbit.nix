{ self, ... }: {
  flake.nixosModules.bookorbit =
    { config, lib, ... }:
    let
      inherit (import ./_traefikModule.nix { inherit lib; }) mkTraefikOptions mkTraefikConfig;
      inherit (lib) mkOption types;
      cfg = config.ironman.bookorbit;
      userName = config.ironman.user.name;
    in
    {
      options.ironman.bookorbit = mkTraefikOptions {
        service = "BookOrbit";
        domain = "bookorbit.home";
        port = "3000";
      } // {
          environmentFile = mkOption {
            default = "";
            description = "Environment file for the bookorbit server";
            type = types.path;
          };
        };
      config = {
        ironman.postgres = {
          inherit (cfg) enable;
          dbName = "bookorbit";
        };
        services = {
          bookorbit = {
            inherit (cfg) enable environmentFile;
            createDatabaseLocally = true;
            group = userName;
            user = userName;
          };
          traefik.dynamicConfigOptions.http = mkTraefikConfig {
            inherit cfg;
            name = "bookorbit";
          };
        };
      };
    };
}
