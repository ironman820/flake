{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.ironman) enabled;
  cfg = config.ironman.xdg;
in
{
  options.ironman.xdg = {
    enable = mkEnableOption "Enable xdg";
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; mkMerge [
        (mkIf config.ironman.hyprland.enable [
          xdg-desktop-portal-hyprland
        ])
        (mkIf config.ironman.gnome.enable [ xdg-desktop-portal-gnome ])
      ];
      xdgOpenUsePortal = true;
    };
  };
}
