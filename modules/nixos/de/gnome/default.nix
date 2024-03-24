{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;
  cfg = config.mine.de.gnome;
in {
  options.mine.de.gnome = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    mine.gpg.pinentryFlavor = "gnome3";
    environment = {
      gnome.excludePackages =
        (with pkgs; [
          gnome-tour
          gnome-photos
        ])
        ++ (with pkgs.gnome; [
          cheese
          gnome-maps
          gnome-software
        ]);
      systemPackages =
        [pkgs.gnome-extension-manager]
        ++ (with pkgs.gnome; [
          gnome-tweaks
          seahorse
        ])
        ++ (with pkgs.gnomeExtensions; [
          appindicator
          caffeine
          compact-top-bar
          lock-keys
          no-overview
          pano
          power-profile-switcher
          syncthing-indicator
          tactile
          weather-oclock
        ]);
    };
    services = {
      gnome.gnome-keyring = enabled;
      udev.packages = with pkgs.gnome; [gnome-settings-daemon];
      xserver = {
        desktopManager.gnome = enabled;
        # displayManager = {
        #   gdm = enabled;
        # };
        enable = true;
        xkb.layout = "us";
      };
    };
  };
}
