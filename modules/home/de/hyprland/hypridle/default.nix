{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;

  cfg = config.mine.home.de.hyprland.hypridle;
in {
  options.mine.home.de.hyprland.hypridle = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    mine.home.hyprlock = enabled;
    services.hypridle = {
      inherit (cfg) enable;
      listeners = [
        {
          timeout = 300;
          onTimeout = "hyprlock";
          onResume = "";
        }
      ];
      lockCmd = "hyprlock";
      unlockCmd = "";
      afterSleepCmd = "";
      beforeSleepCmd = "";
    };
  };
}
