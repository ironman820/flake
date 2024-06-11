{
  cell,
  config,
  inputs,
}: let
  inherit (cell) nixosSuites;
  inherit (inputs) nixos-hardware nixpkgs;
  inherit (inputs.cells) mine;
  inherit (inputs.cells.mine) packages;
  h = nixos-hardware.nixosModules;
  l = nixpkgs.lib // mine.lib // builtins;
  p = cell.nixosProfiles;
  profiles = [
    p.personal-drives
    p.android
  ];
  suites = nixosSuites.laptop';
  v = config.vars;
in {
  imports = l.concatLists [
    [
      cell.bee
      cell.hardwareProfiles.ironman-laptop
      h.common-cpu-intel
      h.common-pc-ssd
    ]
    profiles
    suites
  ];

  home-manager.users.${v.username} = {
    imports = let
      inherit (inputs.cells) gui-apps tui;
      inherit (inputs.cells.home) homeProfiles homeSuites;
      h = homeProfiles // tui.homeProfiles // gui-apps.homeProfiles;
      profiles = with h; [
        hexchat
        personal-email
      ];
      suites = homeSuites.laptop';
    in
      l.concatLists [
        profiles
        suites
      ];
    home.packages = with nixpkgs; [
      calibre
      packages.tochd
    ];
    vars = {
      inherit (config.vars) wallpaper;
      imapfilter.home = true;
      fonts = {
        terminalSize = 10.0;
        waybarSize = 12;
      };
      transparency.terminalOpacity = 0.85;
      waybar.resolution = 768;
    };
  };
  networking.hostName = "ironman-laptop";
  services.tlp.settings.RUNTIME_PM_DISABLE = "02:00.0";
  vars = {
    networking.profiles.work = true;
    wallpaper = ./__ffvii.jpg;
  };
  zramSwap = l.enabled;
}
