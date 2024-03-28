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
          blueman
          bluez
          bluez-tools
          breeze-icons
          brightnessctl
          cliphist
          figlet
          floorp
          freerdp
          gtk4
          grim
          gum
          hyprland
          hyprpaper
          libadwaita
          libnotify
          mako
          man-pages
          meson
          mpv
          nwg-look
          pavucontrol
          pfetch
          polkit_gnome
          pulseaudio
          qt6.qtwayland
          rofi-wayland
          rsync
          slurp
          swaylock-effects
          swww
          unzip
          vlc
          waybar
          wayland-protocols
          wayland-utils
          wget
          wl-clipboard
          wlroots
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
          xwayland
          zathura
        ])
        ++ (with pkgs.libsForQt5; [
          polkit-kde-agent
          qt5.qtwayland
        ])
        ++ (with pkgs.xfce; [
          mousepad
          tumbler
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
