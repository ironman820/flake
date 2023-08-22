{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.default-settings;
in
{
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
        inconsolata-nerdfont
      ];
      useXkbConfig = true; # use xkbOptions in tty.
    };
    environment = {
      systemPackages = (with pkgs; [
        age
        devbox
        fzf
        git-extras
        (nerdfonts.override {
          fonts = [
            "FiraCode"
            "Inconsolata"
          ];
        })
        nix-index
        p7zip
        rnix-lsp
        ssh-to-age
        snowfallorg.flake
        sops
        terminus-nerdfont
        wget
      ]);
    };
    i18n.defaultLocale = "en_US.UTF-8";
    ironman = {
      # java = enabled;
      user = {
        extraGroups = [
          "dialout"
        ];
        passFile = config.sops.secrets.user_pass.path;
      };
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
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
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
    };
    security.sudo = {
      execWheelOnly = true;
    };
    services = {
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
  };
}
