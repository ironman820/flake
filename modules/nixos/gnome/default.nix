{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) disabled enabled;
  cfg = config.ironman.gnome;
in
{
  options.ironman.gnome = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    ironman.gpg.pinentryFlavor = "gnome3";
    environment = {
      gnome.excludePackages = (with pkgs; [
        gnome-tour
        gnome-photos
      ]) ++ (with pkgs.gnome; [
        cheese
        gnome-maps
        gnome-software
      ]);
      systemPackages = with pkgs; [
        gnome.seahorse
      ];
    };
    services = {
      gnome.gnome-keyring = enabled;
      udev.packages = with pkgs.gnome; [ gnome-settings-daemon ];
      xserver = {
        desktopManager.gnome = enabled;
        # displayManager = {
        #   gdm = enabled;
        # };
        enable = true;
        layout = "us";
      };
    };
  };
}
