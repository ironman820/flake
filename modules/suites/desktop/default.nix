{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.suites.desktop;
in {
  options.ironman.suites.desktop = with types; {
    enable = mkBoolOpt false "Whether or not to enable a desktop environment.";
  };

  config = mkIf cfg.enable {
    boot = {
      kernelParams = [
        "quiet"
      ];
    };
    hardware = {
      opengl = enabled;
      pulseaudio = enabled;
    };
    ironman = {
      desktop.gnome = enabled;
      home.extraOptions = {
        home.packages = with pkgs; [
          google-chrome
          restic
          git-filter-repo
          birdtray
          teamviewer
          teams
          virt-viewer
          virt-manager
          devbox
          nodejs_20
          git
          github-cli
          glab
          lazygit
          jq
          yq
          networkmanagerapplet
          (nerdfonts.override { fonts = [ "FiraCode" ]; })
        ];
      };
      networking.putty = enabled;
      yubikey = enabled;
    };
    services = {
      flatpak = enabled;
      printing = enabled;
      xserver = {
        libinput = {
          enable = true;
          touchpad.tapping = true;
        };
      };
    };
    sound = enabled;
  };
}