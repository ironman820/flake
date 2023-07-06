{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.gui-apps;
in {
  options.ironman.gui-apps = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf (cfg.enable && config.ironman.gnome.enable) {
    ironman.home.extraOptions.home.packages = with pkgs; [
      blender
      calibre
      element-desktop-wayland
      firefox
      gimp
      google-chrome
      libreoffice-fresh
      microsoft-edge
      obs-studio
      obsidian
      putty
      telegram-desktop
      vlc
      virt-viewer
      zotero
    ];
  };
}
