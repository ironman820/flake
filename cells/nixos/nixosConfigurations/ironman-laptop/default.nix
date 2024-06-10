{
  cell,
  config,
  inputs,
  ...
}: let
  inherit (cell) nixosSuites;
  inherit (inputs) haumea nixpkgs;
  inherit (inputs.cells) mine;
  inherit (inputs.cells.home) homeProfiles homeSuites;
  inherit (inputs.cells.mine) packages;
  l = nixpkgs.lib // haumea.lib // mine.lib // builtins;
  networking = inputs.cells.networking.nixosProfiles;
  profiles = [
    networking.personal-drives
  ];
  suites = nixosSuites.laptop';
  v = config.vars;
in {
  imports = l.concatLists [
    [
      cell.bee
      cell.hardwareProfiles.ironman-laptop
    ]
    profiles
    suites
  ];
  # [
  #   hyprland.nixosModules.default
  #   (cell.nixosModules.home homeModules)
  #   cell.nixosModules.default
  #   {system.stateVersion = stateVersion;}
  # ]
  # ++ nixosModules;

  home-manager.users.${v.username} = {
    imports = let
      gui-apps = inputs.cells.gui-apps.homeProfiles;
      profiles = with homeProfiles; [
        gui-apps.hexchat
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
      stylix = {
        inherit (config.vars.stylix) image;
        fonts = {
          terminalSize = 10.0;
          waybarSize = 12;
        };
      };
      transparancy.terminalOpacity = 0.85;
    };
    waybar.resolution = 768;
  };
  networking.hostName = "ironman-laptop";
  #   # mine = {
  #   #   android = enabled;
  #   #   user.settings.stylix.image = ./ffvii.jpg;
  #   #   networking.profiles.work = true;
  #   # };
  #   # environment.systemPackages = [
  #   #   pkgs.devenv
  #   # ];
  #   services.tlp.settings.RUNTIME_PM_DISABLE = "02:00.0";
  #   zramSwap = l.enabled;
  # };
  vars.stylix.image = ./__ffvii.jpg;
}
