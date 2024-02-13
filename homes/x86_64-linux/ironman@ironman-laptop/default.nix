{ lib, pkgs, ...}:
let
  inherit (lib.ironman) enabled;
in
{
  ironman.home = {
    gui-apps.hexchat = true;
    networking = enabled;
    personal-apps = enabled;
    programs = {
      neomutt = {
        enable = true;
        personalEmail = true;
      };
      ranger = enabled;
    };
    qtile = {
      enable = true;
      backlightDisplay = "intel_backlight";
      screenSizeCommand = "xrandr --output eDP-1 --primary --auto --scale 1.2";
    };
    suites.workstation = enabled;
  };
}
