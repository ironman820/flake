{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkDefault mkIf;
  inherit (lib.ironman) enabled mkBoolOpt;
  cfg = config.ironman.default-settings;
in
{
  options.ironman.default-settings = {
    enable = mkBoolOpt true "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    boot = {
      kernelParams = [
        "quiet"
      ];
      loader = {
        efi.canTouchEfiVariables = true;
        timeout = mkDefault 2;
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
        fzf
        git-extras
        nerdfonts
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
      nix = enabled;
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
    nixpkgs.config.allowUnfree = true;
    programs = {
      direnv = {
        enable = true;
        nix-direnv = enabled;
      };
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
          PermitRootLogin = mkDefault "no";
        };
      };
    };
    systemd.extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
    time.timeZone = "America/Chicago";
  };
}
