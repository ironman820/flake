{lib, ...}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    ../modules.nix
  ];
  mine.home = {
    gui-apps.hexchat = true;
    hyprland = {
      enable = true;
      primaryScale = "0.8";
      wallpaper = ../../../systems/x86_64-linux/ironman-laptop/scream.jpg;
    };
    impermanence = enabled;
    networking = enabled;
    personal-apps = enabled;
    neomutt = {
      enable = true;
      personalEmail = true;
    };
    ranger = enabled;
    qtile = {
      enable = true;
      backlightDisplay = "intel_backlight";
      screenSizeCommand = "xrandr --output eDP-1 --primary --auto --scale 1.2";
    };
    suites.workstation = enabled;
  };
}
