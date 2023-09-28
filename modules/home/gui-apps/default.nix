{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.home.gui-apps;
in
{
  options.ironman.home.gui-apps = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf (cfg.enable && config.ironman.home.gnome.enable) {
    home.packages = with pkgs; [
      blender
      element-desktop-wayland
      firefox
      gimp
      github-desktop
      google-chrome
      libreoffice-fresh
      microsoft-edge
      obs-studio
      obsidian
      putty
      remmina
      telegram-desktop
      vlc
      virt-viewer
      zotero
    ];
  };
}
