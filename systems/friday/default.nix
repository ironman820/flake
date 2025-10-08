{
  lib,
  pkgs,
  self',
  ...
}:
let
  inherit (lib.mine) disabled enabled;
in
{
  imports = [
    ./hardware.nix
    ./disko.nix
  ];
  config = {
    boot = {
      loader.grub = {
        efiSupport = true;
        device = "nodev";
        theme = "${pkgs.grub-cyberexs}/share/grub/themes/CyberEXS";
      };
      plymouth = enabled;
    };
    environment = {
      shellInit = ''
        gpg-connect-agent /bye
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      '';
      systemPackages = with pkgs; [
        audacity
        blender
        calibre
        self'.packages.catppuccin-kitty
        (catppuccin-sddm.override {
          flavor = "mocha";
        })
        firmware-manager
        kitty
        gimp
        gnupg
        libreoffice-fresh
        mmex
        obs-studio
        pavucontrol
        pipewire
        putty
        remmina
        telegram-desktop
        udiskie
        vlc
        virt-viewer
        yubikey-personalization
      ];
    };
    hardware = {
      bluetooth = enabled;
      gpgSmartcards = enabled;
    };
    mine.networking = {
      basic.networkmanager = enabled;
      profiles = enabled // {
        work = true;
      };
    };
    nixpkgs.config.allowUnfree = true;
    powerManagement = enabled // {
      powertop = enabled;
    };
    programs = {
      gnupg.agent = enabled // {
        enableSSHSupport = true;
      };
      java = enabled // {
        binfmt = true;
        package = pkgs.jdk17;
      };
      ssh = {
        enableAskPassword = true;
        startAgent = false;
      };
      winbox = enabled // {
        package = pkgs.winbox4;
      };
    };
    security = {
      pam.u2f = enabled // {
        settings = {
          cue = true;
          origin = "pam://ironman";
        };
      };
      rtkit = enabled;
    };
    services = {
      desktopManager.plasma6 = enabled;
      displayManager.sddm = enabled // {
        enableHidpi = true;
        theme = "catppuccin-mocha";
        wayland = enabled;
      };
      fwupd = enabled;
      logind = {
        killUserProcesses = true;
        lidSwitchExternalPower = "ignore";
      };
      pcscd = enabled;
      pipewire = enabled // {
        alsa = enabled // {
          support32Bit = true;
        };
        pulse = enabled;
      };
      power-profiles-daemon = disabled;
      pulseaudio = disabled;
      resilio = enabled // {
        checkForUpdates = false;
        enableWebUI = true;
      };
      # system76-scheduler.settings.cfsProfiles = enabled;
      thermald = enabled;
      tlp = enabled // {
        settings = {
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          SATA_LINKPWR_ON_BAT = "med_power_with_dipm min_power";
          WIFI_PWR_ON_AC = "off";
          WIFI_PWR_ON_BAT = "off";
        };
      };
      udev.packages = with pkgs; [
        yubikey-personalization
      ];
      yubikey-agent = enabled;
    };
    sops = {
      age = {
        keyFile = "/etc/nixos/keys.txt";
        sshKeyPaths = [ ];
      };
      defaultSopsFile = ./secrets/sops.yaml;
      gnupg.sshKeyPaths = [ ];
    };
    system.stateVersion = "25.05";
  };
}
