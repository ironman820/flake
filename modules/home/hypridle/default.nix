{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;

  cfg = config.mine.home.hypridle;
in {
  options.mine.home.hypridle = {
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
