{ config, lib, pkgs, system, ... }:

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
      packages = with pkgs; [
        terminus-nerdfont
      ];
      useXkbConfig = true; # use xkbOptions in tty.
    };
    environment = {
      gnome.excludePackages = (with pkgs; [
        gnome-tour
        gnome-photos
      ]) ++ (with pkgs.gnome; [
        cheese
        gnome-maps
        gnome-software
      ]);
      shellInit = ''
        gpg-connect-agent /bye
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      '';
      systemPackages = (with pkgs; [
        age
        devbox
        distrobox
        fzf
        gnupg
        libva-utils
        networkmanagerapplet
        ntfs3g
        podman-compose
        ssh-to-age
        snowfallorg.flake
        sops
        terminus-nerdfont
        vim
        wget
        yubikey-personalization
      ]);
    };
    hardware = {
      opengl = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          libvdpau-va-gl
          vaapiIntel
          vaapiVdpau
        ];
      };
      pulseaudio = disabled;
    };
    i18n.defaultLocale = "en_US.UTF-8";
    ironman = {
      user.extraGroups = [
        "dialout"
        "libvirtd"
        "networkmanager"
      ];
    };
    location.provider = "geoclue2";
    networking = {
      enableIPv6 = false;
      firewall = {
        allowedTCPPorts = [
          22000
        ];
        allowedUDPPorts = [
          5678
          21027
          22000
        ];
      };
      networkmanager = {
        enable = true;
        plugins = with pkgs.gnome; [
          networkmanager-openvpn
        ];
        profiles = {
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
        auto-optimise-store = true;
        cores = 2;
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
      git = {
        enable = true;
        lfs = enabled;
      };
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
      mtr = enabled;
      # nix-ld is needed for gloCOM
      # nix-ld.dev = enabled;
      ssh.startAgent = false;
      vim.defaultEditor = true;
      xwayland = enabled;
    };
    security.sudo = {
      execWheelOnly = true;
      wheelNeedsPassword = false;
    };
    services = {
      flatpak = enabled;
      gnome.gnome-keyring = enabled;
      logind.killUserProcesses = true;
      openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
        };
      };
      pcscd.enable = true;
      pipewire = {
        alsa = enabled;
        enable = true;
        pulse = enabled;
      };
      printing = enabled;
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
          touchpad.naturalScrolling = true;
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
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket = enabled;
      };
    };
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
    zramSwap = {
      enable = true;
      memoryPercent = 90;
    };
  };
}
