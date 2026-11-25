{
  flake.nixosModules.bookorbit =
    { config, lib, ... }:
    let
      inherit (lib) mkOption types;
      cfg = config.ironman.bookorbit;
      userName = config.ironman.user.name;
    in
    {
      options.ironman.bookorbit = {
        environmentFile = mkOption {
          default = "";
          description = "Environment file for the bookorbit server";
          type = types.path;
        };
      };
      config = {
        ironman.postgres = {
          enable = true;
          dbName = "bookorbit";
        };
        services = {
          bookorbit = {
            inherit (cfg) environmentFile;
            enable = true;
            createDatabaseLocally = true;
            group = userName;
            user = userName;
          };
        };
      };
    };
}
