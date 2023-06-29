{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.desktop.gnome;
in {
  options.ironman.desktop.gnome = with types; {
    enable = mkBoolOpt false "Whether or not to enable Gnome.";
  };

  config = mkIf cfg.enable {
    environment = {
      gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-photos
      ];

      systemPackages = (with pkgs; [
        gnome-extension-manager
        gnome.gnome-tweaks
      ]) ++ (with pkgs.gnomeExtensions; [
        appindicator
        caffeine
        compact-top-bar
        lock-keys
        no-overview
        pano
        power-profile-switcher
        tactile
        wallpaper-switcher
        weather-oclock
      ]);
    };
    programs.dconf = enabled;
    services = {
      gnome.gnome-keyring = enabled;
      xserver = {
        desktopManager.gnome = enabled;
        displayManager = {
          defaultSession = "gnome";
          gdm = enabled;
        };
        enable = true;
        layout = "us";
      };
    };
    xdg.portal = enabled;
    ironman.home.extraOptions = {
      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.tela-icon-theme;
          name = "Tela-black-dark";
        };
        theme = {
          package = pkgs.orchis-theme;
          name = "Orchis-Dark-Compact";
        };
      };
    };
  };
}