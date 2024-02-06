{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;
  cfg = config.mine.qtile;
in {
  options.mine.qtile = {
    enable = mkEnableOption "Set up qtile window manager";
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      (with pkgs; [
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
      ])
      ++ (with pkgs.xfce; [
        thunar
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ]);
    services = {
      gvfs = enabled;
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
