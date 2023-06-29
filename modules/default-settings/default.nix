{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.ironman.default-settings;
  hash = "sha256:0x18qkwxfzmhbn6cn2da0xn27mxnmiw56qwx3kjvy9ljcar5czvh";
in {
  imports = [
    (import (builtins.fetchTarball {
      url = "https://github.com/jmackie/nixos-networkmanager-profiles/archive/master.tar.gz";
      sha256 = hash;
    }))
  ];

  options.ironman.default-settings = with types; {
    enable = mkBoolOpt true "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    boot = {
      kernelParams = [
        "i915.modeset=1"
        "i915.fastboot=1"
        "i915.enable_guc=2"
        "i915.enable_psr=1"
        "i915.enable_fbc=1"
        "i915.enable_dc=2"
        "quiet"
      ];
      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          efiSupport = true;
          device = "nodev";
          theme = pkgs.nixos-grub2-theme;
        };
        timeout = 2;
      };
      plymouth = {
        enable = true;
        theme = "nixos-bgrt";
        themePackages = [
          pkgs.nixos-bgrt-plymouth
        ];
      };
    };
    console = {
      font = "Lat2-Terminus16";
      useXkbConfig = true; # use xkbOptions in tty.
    };
    environment = {
      gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-photos
      ];
      shellInit = ''
        gpg-connect-agent /bye
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      '';
      systemPackages = (with pkgs; [
        devbox
        distrobox
        gnome.gnome-tweaks
        gnome-extension-manager
        gnupg
        ntfs3g
        podman-compose
        vim
        wget
        yubikey-personalization
      ]) ++ (with pkgs.gnomeExtensions; [
        syncthing-indicator
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
    hardware = {
      opengl = enabled;
      pulseaudio = enabled;
    };
    i18n.defaultLocale = "en_US.UTF-8";
    ironman = {
      user.extraGroups = [
        "dialout"
      ];
    };
    location.provider = "geoclue2";
    networking = {
      networkmanager.profiles = {
        "DumbledoresArmy" = {
          connection = {
            type = "wifi";
            permissions = "";
            id = "DumbledoresArmy";
            uuid = "9725c49f-5808-4663-8d9f-d8d7bd38cf7d";
          };
          wifi = {
            mac-address-blacklist = "";
            mode = "infrastructure";
            ssid = "DumbledoresArmy";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "Alohomora";
          };
          ipv4 = {
            dns-search = "";
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "stable-privacy";
            dns-search = "";
            method = "auto";
          };
        };
      };
      nftables = enabled;
    };
    nix = {
      gc.automatic = true;
      generateNixPathFromInputs = true;
      generateRegistryFromInputs = true;
      linkInputs = true;
      optimise.automatic = true;
      settings = {
        cores = 3;
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users = [
          "root"
          "ironman"
        ];
      };
    };
    nixpkgs.config.allowUnfree = true;
    programs = {
      dconf = enabled;
      git = enabled;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
      mtr = enabled;
      ssh.startAgent = false;
      vim.defaultEditor = true;
    };
    security.sudo = {
      execWheelOnly = true;
      extraRules = mkBefore [
        {
          commands = [
            {
              command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
              options = [ "NOPASSWD" ];
            }
          ];
          runAs = "ALL";
          users = [ "${config.ironman.user.name}" ];
        }
      ];
    };
    services = {
      flatpak = enabled;
      gnome.gnome-keyring = enabled;
      logind.killUserProcesses = true;
      openssh = enabled;
      pcscd.enable = true;
      printing = enabled;
      syncthing = {
        dataDir = "/home/${config.ironman.user.name}";
        enable = true;
        user = config.ironman.user.name;
        openDefaultPorts = true;
      };
      udev.packages = with pkgs; [
        yubikey-personalization
      ];
      xserver = {
        desktopManager.gnome = enabled;
        displayManager = {
          defaultSession = "gnome";
          gdm = enabled;
        };
        enable = true;
        layout = "us";
        libinput = {
          enable = true;
          touchpad.tapping = true;
        };
      };
    };
    sound = enabled;
    systemd.extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
    time.timeZone = "America/Chicago";
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.package = pkgs.qemu_kvm;
      };
      podman = enabled;
    };
    xdg.portal = enabled;
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 90;
    };
  };
}