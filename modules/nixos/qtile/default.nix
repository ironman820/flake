{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled;
  cfg = config.ironman.qtile;
in {
  options.ironman.qtile = {
    enable = mkEnableOption "Set up qtile window manager";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = (with pkgs; [
      alacritty
      bashmount
      bibata-cursors
      bibata-cursors-translucent
      brightnessctl
      catppuccin-cursors
      catppuccin-gtk
      catppuccin-kvantum
      catppuccin-papirus-folders
      feh
      floorp
      pywal
      rofi
      scrot
    ]) ++ (with pkgs.xfce; [
      thunar
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-volman
    ]);
    services = {
      udisks2 = enabled;
      xserver.windowManager.qtile = {
        enable = true;
        # extraPackages = py: with py; [
        #   qtile-extras
        # ];
      };
    };
  };
}
