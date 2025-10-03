{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.mine) enabled;
in {
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
      timeout = 2;
    };
  };
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };
  environment.systemPackages =
    (with pkgs; [
      age
      appimage-run
      bashmount
      bat
      btop
      # catppuccin-btop
      delta
      entr
      eza
      # flake
      fzf
      git-extras
      lazygit
      p7zip
      ssh-to-age
      snowfallorg.flake
      sops
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
  fonts.packages = with pkgs;
    [
      meslo-lgs-nf
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  hardware.enableRedistributableFirmware = true;
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  mine.user.extraGroups = [
    "dialout"
  ];
  location.provider = "geoclue2";
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" "@wheel"];
  };
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
}
