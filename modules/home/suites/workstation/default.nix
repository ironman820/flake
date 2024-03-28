{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;
  cfg = config.mine.home.suites.workstation;
in {
  options.mine.home.suites.workstation = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    mine.home = {
      hyprland = enabled;
      rofi = enabled;
      sync = enabled;
      video-tools = enabled;
      virtual-host = enabled;
      yubikey = enabled;
    };
  };
}
