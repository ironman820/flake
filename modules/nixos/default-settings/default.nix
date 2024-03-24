{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkIf;
  inherit (lib.mine) enabled mkBoolOpt;
  cfg = config.mine.default-settings;
  imp = config.mine.impermanence.enable;
in {
  options.mine.default-settings = {
    enable = mkBoolOpt true "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    boot = {
      kernel.sysctl = {
        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_congestion_control" = "bbr";
        "vm.swappiness" = 10;
      };
      kernelModules = ["tcp_bbr"];
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
      persistence."/persist/root".directories = mkIf imp [
        "/var/db/sudo"
      ];
      systemPackages =
        (with pkgs; [
          age
          appimage-run
          bashmount
          bat
          btop
          catppuccin-btop
          delta
          entr
          eza
          fzf
          git-extras
          nerdfonts
          p7zip
          # rnix-lsp
          ssh-to-age
          flake
          sops
          steam-run
          terminus-nerdfont
          wget
        ])
        ++ (with pkgs.bat-extras; [
          batdiff
          batgrep
          batman
          batpipe
          batwatch
          prettybat
        ]);
    };
    fonts.packages = with pkgs; [
      nerdfonts
      meslo-lgs-nf
    ];
    i18n.defaultLocale = "en_US.UTF-8";
    mine.user.extraGroups = [
      "dialout"
    ];
    location.provider = "geoclue2";
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
    systemd.extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
    time.timeZone = "America/Chicago";
  };
}
