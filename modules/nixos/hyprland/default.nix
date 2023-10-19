{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) disabled enabled;
  cfg = config.ironman.hyprland;
in
{
  options.ironman.hyprland = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libnotify
      mako
      rofi-wayland
      swww
      waybar
      # (waybar.overrideAttrs (oldAttrs: {
      #   mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      #   })
      # )
    ];
    programs.hyprland = enabled;
    xdg.portal = {
      enable = true;
    };
  };
}
