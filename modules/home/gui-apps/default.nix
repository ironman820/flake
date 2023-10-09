{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.home.gui-apps;
in
{
  options.ironman.home.gui-apps = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf (cfg.enable && config.ironman.home.gnome.enable) {
    home.packages = with pkgs; [
      blender
      element-desktop-wayland
      firefox
      gimp
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
