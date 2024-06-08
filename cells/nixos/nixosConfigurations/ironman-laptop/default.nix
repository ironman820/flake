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

  # config = {
  home-manager.users.${v.username} = {
    imports = let
      gui-apps = inputs.cells.gui-apps.homeProfiles;
      profiles = with homeProfiles; [
        gui-apps.hexchat
      ];
      suites = with homeSuites;
        l.concatLists [
          base
        ];
    in
      l.concatLists [
        profiles
        suites
      ];
    home.packages = [
      packages.tochd
    ];
  };
  networking.hostName = "ironman-laptop";
  #   # mine = {
  #   #   android = enabled;
  #   #   suites.laptop = enabled;
  #   #   user.settings.stylix.image = ./ffvii.jpg;
  #   #   networking.profiles.work = true;
  #   # };
  #   # environment.systemPackages = [
  #   #   pkgs.devenv
  #   # ];
  #   services.tlp.settings.RUNTIME_PM_DISABLE = "02:00.0";
  #   zramSwap = l.enabled;
  # };
}
