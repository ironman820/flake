{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.default-settings;
in {
  options.ironman.default-settings = with types; {
    enable = mkBoolOpt true "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    boot = {
      kernelParams = [
        "quiet"
      ];
      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 2;
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
      systemPackages = (with pkgs; [
        age
        devbox
        distrobox
        fzf
        git-extras
        nix-index
        p7zip
        podman-compose
        ssh-to-age
        snowfallorg.flake
        sops
        terminus-nerdfont
        vim
        wget
      ]);
    };
    i18n.defaultLocale = "en_US.UTF-8";
    ironman = {
      # java = enabled;
      user.extraGroups = [
        "dialout"
      ];
    };
    location.provider = "geoclue2";
    networking = {
      enableIPv6 = false;
      firewall.allowedUDPPorts = [
        1900
      ];
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
          "${config.ironman.user.name}"
        ];
      };
    };
    nixpkgs.config.allowUnfree = true;
    programs = {
      git = {
        enable = true;
        lfs = enabled;
      };
      mtr = enabled;
      vim.defaultEditor = true;
    };
    security.sudo = {
      execWheelOnly = true;
    };
    services = {
      logind.killUserProcesses = true;
      openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
        };
      };
    };
    systemd.extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
    time.timeZone = "America/Chicago";
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket = enabled;
      };
    };
  };
}
