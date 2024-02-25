{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;
  cfg = config.mine.hyprland;
in {
  options.mine.hyprland = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    mine = {
      gpg.pinentryFlavor = "qt";
      sddm = {
        enable = true;
        wayland = true;
      };
      xdg = enabled;
    };
    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";
      systemPackages =
        (with pkgs; [
          hyprland
          hyprpaper
          libnotify
          mako
          meson
          qt6.qtwayland
          rofi-wayland
          swaylock-effects
          waybar
          wayland-protocols
          wayland-utils
          wl-clipboard
          wlroots
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
          xwayland
        ])
        ++ (with pkgs.libsForQt5; [
          polkit-kde-agent
          qt5.qtwayland
        ]);
    };
    programs = {
      dconf = enabled;
      hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        xwayland = enabled;
      };
    };
    security.pam.services.swaylock = {};
    services = {
      dbus = enabled;
      xserver = {
        enable = true;
        xkb.layout = "us";
      };
    };
  };
}
