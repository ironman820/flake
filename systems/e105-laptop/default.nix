{ pkgs, config, ... }:
{
  imports = [
    ./hardware.nix
  ];

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
      inconsolata-nerdfont
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
      gcc
      git-extras
      glibc
      gnome.seahorse
      gnupg
      libva-utils
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "Inconsolata"
        ];
      })
      networkmanagerapplet
      nix-index
      ntfs3g
      p7zip
      podman-compose
      rnix-lsp
      ssh-to-age
      sops
      terminus-nerdfont
      yubikey-personalization
      wget
    ]);
  };
  hardware = {
    bluetooth.enable = true;
    gpgSmartcards.enable = true;
    opengl.enable = true;
    pulseaudio.enable = false;
  };
  home-manager.users.${config.ironman.user.name} = import ../../homes/${config.ironman.user.name} {
    inherit config pkgs;
    username = config.ironman.user.name;
  };
  i18n.defaultLocale = "en_US.UTF-8";
  location.provider = "geoclue2";
  networking = {
    enableIPv6 = false;
    firewall = {
      allowedTCPPorts = [
        8291
        8384
        22000
        24800
      ];
      allowedUDPPorts = [
        1900
        5678
        20561
        21027
        22000
      ];
    };
    networkmanager = {
      enable = true;
      plugins = with pkgs.gnome; [
        networkmanager-openvpn
      ];
    };
    nftables.enable = true;
  };
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      cores = 2;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [
        "root"
        "niceastman"
      ];
    };
  };
  programs = {
    dconf.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3";
    };
    java = {
      binfmt = true;
      enable = true;
      package = pkgs.jdk17;
    };
    mtr.enable = true;
    nix-ld.enable = true;
    ssh = {
      enableAskPassword = true;
      startAgent = false;
    };
    xwayland.enable = true;
  };
  security = {
    pam.u2f = {
      enable = true;
      cue = true;
      origin = "pam://ironman";
    };
    rtkit.enable = true;
    sudo = {
      execWheelOnly = true;
    };
  };
  services = {
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    logind = {
      killUserProcesses = true;
      lidSwitchExternalPower = "ignore";
    };
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    pcscd.enable = true;
    pipewire = {
      alsa.enable = true;
      enable = true;
      pulse.enable = true;
    };
    printing.enable = true;
    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
      yubikey-personalization
    ];
    xserver = {
      desktopManager.gnome.enable = true;
      displayManager = {
        defaultSession = "gnome";
        gdm.enable = true;
      };
      enable = true;
      layout = "us";
      libinput = {
        enable = true;
        touchpad.naturalScrolling = true;
      };
    };
    yubikey-agent.enable = true;
  };
  sops = {
    age.keyFile = "/etc/nixos/keys.txt";
    secrets = {
      da_psk = {
        format = "binary";
        mode = "0400";
        path = "/etc/NetworkManager/system-connections/DumbledoresArmy.nmconnection";
        sopsFile = ../../secrets/da.wifi;
      };
      office_psk = {
        format = "binary";
        mode = "0400";
        path = "/etc/NetworkManager/system-connections/office.nmconnection";
        sopsFile = ../../secrets/office.wifi;
      };
      user_pass = {
        mode = "0400";
        neededForUsers = true;
        sopsFile = ../../secrets/sops.yaml;
      };
    };
  };
  sound.enable = true;
  system.stateVersion = "23.05";
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';
  time.timeZone = "America/Chicago";
  users.users.${config.ironman.user.name} = {
    extraGroups = [
      "dialout"
      "libvirtd"
      "networkmanager"
      "wheel"
    ];
    isNormalUser = true;
    home = "/home/${config.ironman.user.name}";
    group = "users";
    passwordFile = config.sops.secrets.user_pass.path;
    shell = pkgs.bash;
    uid = 1000;
  };
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm;
    };
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };
}
