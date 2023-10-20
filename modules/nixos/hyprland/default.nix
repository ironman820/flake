{ config, inputs, lib, pkgs, system, ... }:
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
    ironman.gpg.pinentryFlavor = "qt";
    environment.systemPackages = with pkgs; [
      hyprpaper
      libnotify
      mako
      libsForQt5.polkit-kde-agent
      libsForQt5.qt5.qtwayland
      qt6.qtwayland
      rofi-wayland
      swaylock-effects
      inputs.watershot.packages.${pkgs.system}.default
      waybar
      # (waybar.overrideAttrs (oldAttrs: {
      #   mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      #   })
      # )
    ];
    programs = {
      dconf = enabled;
      hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${system}.hyprland;
      };
      xwayland = enabled;
    };
    security.pam.services.swaylock = {};
    services.xserver = {
      enable = true;
      layout = "us";
    };
  };
}
