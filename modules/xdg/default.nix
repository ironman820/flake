{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.mine.xdg;
in {
  options.mine.xdg = {
    enable = mkEnableOption "Enable xdg";
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      inherit (cfg) enable;
      config.common.default = "*";
      extraPortals = with pkgs;
        mkMerge [
          (mkIf config.mine.gnome.enable [xdg-desktop-portal-gnome])
          (mkIf config.mine.hyprland.enable [
            xdg-desktop-portal-hyprland
          ])
          (mkIf config.mine.qtile.enable [
            xdg-desktop-portal-gtk
          ])
        ];
      xdgOpenUsePortal = true;
    };
  };
}
