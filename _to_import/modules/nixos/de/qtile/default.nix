{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;

  cfg = config.mine.de.qtile;
in {
  options.mine.de.qtile = {
    enable = mkEnableOption "Set up qtile window manager";
  };

  config = mkIf cfg.enable {
    mine.gui-apps.thunar = enabled;
    environment.systemPackages = with pkgs; [
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
    ];
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
