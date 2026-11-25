{
  flake.nixosModules.navidrome =
    { config, lib, ... }:
    let
      inherit (lib) mkOption;
      inherit (lib.types) path;
      cfg = config.ironman.navidrome;
      user = config.ironman.user.name;
    in
    {
      options.ironman.navidrome = {
        DataFolder = mkOption {
          default = "/data/navidrome";
          description = "The data folder for configuration of Navidrome";
          type = path;
        };
        environmentFile = mkOption {
          description = "Path to the environment file for navidrome";
          type = path;
        };
        MusicFolder = mkOption {
          default = "/data/music";
          description = "Folder with the music";
          type = path;
        };
      };
      config = {
        services = {
          navidrome = {
            inherit (cfg) environmentFile;
            inherit user;
            enable = true;
            group = user;
            settings = {
              inherit (cfg) DataFolder MusicFolder;
              Address = "0.0.0.0";
              DefaultUIVolume = "75";
              EnableInsightsCollector = false;
              EnforceNonRootUser = true;
            };
          };
        };
      };
    };
}
