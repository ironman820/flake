{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.ironman.xdg;
in
{
  options.ironman.xdg = {
    enable = mkEnableOption "Enable xdg";
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      inherit (cfg) enable;
      config.common.default = "*";
      extraPortals = with pkgs; mkMerge [
        (mkIf config.ironman.gnome.enable [ xdg-desktop-portal-gnome ])
        (mkIf config.ironman.hyprland.enable [
          xdg-desktop-portal-hyprland
        ])
        (mkIf config.ironman.qtile.enable [
          xdg-desktop-portal-gtk
        ])
      ];
      xdgOpenUsePortal = true;
    };
  };
}
