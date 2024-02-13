{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.types) str;
  inherit (lib.ironman) mkOpt;
  inherit (pkgs) writeShellScript;

  cfg = config.ironman.home.qtile;
in {
  options.ironman.home.qtile = {
    enable = mkEnableOption "Enable the qtile file manager";
    backlightDisplay = mkOpt str "acpi_video0" "Display to monitor backlight";
    screenSizeCommand =
      mkOpt str "" "Command to run to change the screen resolution.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ flameshot zathura ];
    xdg.configFile = {
      "qtile/autostart.sh".source = writeShellScript "autostart.sh" ''
        ${cfg.screenSizeCommand}
        nm-applet &
      '';
      "qtile/config.py".source = ./config/config.py;
      "qtile/display.py".text = ''
        watch_display = "${cfg.backlightDisplay}"
      '';
      "qtile/settings".source = ./config/settings;
    };
  };
}
