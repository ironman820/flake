{
  cell,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
in {
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
    gnome.gnome-keyring = l.enabled;
    udev.packages = with pkgs.gnome; [gnome-settings-daemon];
    xserver = {
      desktopManager.gnome = l.enabled;
      # displayManager = {
      #   gdm = enabled;
      # };
      enable = true;
      xkb.layout = "us";
    };
  };
}
