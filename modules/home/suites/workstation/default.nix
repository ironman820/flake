{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) disabled enabled;
  cfg = config.ironman.home.suites.workstation;
in {
  options.ironman.home.suites.workstation = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    ironman.home = {
      gui-apps = enabled;
      hyprland = enabled;
      rofi = enabled;
      sync = enabled;
      video-tools = enabled;
      virtual.host = enabled;
      yubikey = enabled;
    };
  };
}
