{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake = {
    nixosModules.feishin = moduleWithSystem (
      perSystem@{ ... }:
      { config, lib, ... }:
      let
        inherit (lib) mkEnableOption mkOption types;
        cfg = config.ironman.feishin;
      in
      {
        options.ironman.feishin = {
          enable = mkEnableOption "Install Feishin server";
          ip = mkOption {
            default = "";
            description = "IP address of the server";
            type = types.str;
          };
        };
        config.services = {
          feishin = {
          inherit (cfg) enable;
          domain = "mymusic.niceastman.com";
            pathbase = "/shares/data/music";
            settings = {
              ANALYTICS_DISABLED = "true";
              SERVER_NAME = "Ironman's Music";
            };
        };
        };
      }
    );
    homeModules.feishin = moduleWithSystem (
      perSystem@{ ... }:
      _: {
      }
    );
  };
}
