{
  config,
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
