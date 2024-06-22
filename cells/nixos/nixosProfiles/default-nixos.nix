{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  p = mine.packages;
  v = config.vars;
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
      timeout = l.mkDefault 2;
    };
  };
  console = {
    font = "Lat2-Terminus16";
    packages = with p; [
      nerdfonts
    ];
    useXkbConfig = true; # use xkbOptions in tty.
  };
  environment.systemPackages =
    (with pkgs; [
      age
      appimage-run
      bashmount
      bat
      btop
      delta
      entr
      eza
      fzf
      git-extras
      p.nerdfonts
      p7zip
      ssh-to-age
      sops
      steam-run
      wget
      just
      tealdeer
    ])
    ++ (with pkgs.bat-extras; [
      batdiff
      batgrep
      batman
      batpipe
      batwatch
      prettybat
    ]);
  fonts.packages = with pkgs; [
    p.nerdfonts
    meslo-lgs-nf
  ];
  hardware.enableRedistributableFirmware = true;
  i18n.defaultLocale = "en_US.UTF-8";
  location.provider = "geoclue2";
  programs = {
    direnv = {
      enable = true;
      nix-direnv = l.enabled;
    };
    git = {
      enable = true;
      lfs = l.enabled;
    };
    mtr = l.enabled;
  };
  security.sudo = {
    execWheelOnly = true;
  };
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';
  time.timeZone = "America/Chicago";
  users.users.${v.username} = {
    createHome = true;
    extraGroups = [
      "dialout"
      "wheel"
    ];
    group = "users";
    hashedPasswordFile = config.sops.secrets.user_pass.path;
    home = "/home/${v.username}";
    isNormalUser = true;
    shell = pkgs.bash;
    uid = 1000;
  };
}
