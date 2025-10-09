{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine.user.settings.applications) terminal;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;
  cfg = config.mine.de.hyprland;
in {
  options.mine.de.hyprland = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    mine = {
      de.hyprland.dunst = enabled;
      dm.sddm = {
        enable = true;
        wayland = true;
      };
      gui-apps = {
        alacritty = mkIf (terminal == "alacritty") enabled;
        kitty = mkIf (terminal == "kitty") enabled;
        thunar = enabled;
        wezterm = mkIf (terminal == "wezterm") enabled;
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
          eza
          figlet
          freerdp
          gnome.adwaita-icon-theme
          gtk4
          grim
          gum
          hyprland
          hyprpaper
          libnotify
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
          swappy
          swaylock-effects
          unzip
          vlc
          waybar
          wayland-protocols
          wayland-utils
          wget
          wl-clipboard
          wlroots
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
    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };
}
