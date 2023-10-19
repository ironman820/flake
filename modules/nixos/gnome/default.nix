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
    hardware.pulseaudio = disabled;
    networking = {
      firewall.allowedUDPPorts = [
        5678
      ];
    };
    programs = {
      dconf = enabled;
      gnupg.agent.pinentryFlavor = "gnome3";
      xwayland = enabled;
    };
    security.rtkit = enabled;
    services = {
      flatpak = enabled;
      gnome.gnome-keyring = enabled;
      pipewire = {
        alsa = enabled;
        enable = true;
        pulse = enabled;
      };
      printing = enabled;
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
    sound = enabled;
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}
