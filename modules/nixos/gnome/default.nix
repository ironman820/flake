{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.gnome;
in
{
  options.ironman.gnome = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
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
        networkmanagerapplet
      ];
    };
    hardware.pulseaudio = disabled;
    ironman.user.extraGroups = [
      "networkmanager"
    ];
    networking = {
      firewall.allowedUDPPorts = [
        5678
      ];
      networkmanager = {
        enable = true;
        plugins = with pkgs.gnome; [
          networkmanager-openvpn
        ];
      };
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
        displayManager = {
          defaultSession = "gnome";
          gdm = enabled;
        };
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
