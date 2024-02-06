{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;
  cfg = config.mine.gnome;
in {
  options.mine.gnome = {
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
      systemPackages = with pkgs; [
        gnome.seahorse
      ];
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
        layout = "us";
      };
    };
  };
}
