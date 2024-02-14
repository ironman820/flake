{
  inputs,
  lib,
  ...
}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  mine.home = {
    gui-apps.hexchat = true;
    hyprland = {
      enable = true;
      wallpaper = ../../../systems/x86_64-linux/ironman-laptop/scream.jpg;
    };
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
