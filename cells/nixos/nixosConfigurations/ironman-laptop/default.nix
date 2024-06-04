{
  cell,
  inputs,
  ...
}: let
  inherit (inputs) haumea nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // haumea.lib // mine.lib // builtins;
in {
  imports = l.concatLists [
    [
      cell.bee
      cell.hardwareProfiles.ironman-laptop
    ]
  ];
  # [
  # ../../../common/drives/personal.nix
  # ];
  # [
  #   hyprland.nixosModules.default
  #   home-manager.nixosModules.home-manager
  #   (cell.nixosModules.home homeModules)
  #   cell.nixosModules.default
  #   {system.stateVersion = stateVersion;}
  # ]
  # ++ nixosModules;

  # config = {
  # networking.hostname = "ironman-laptop";
  #   # mine = {
  #   #   android = enabled;
  #   #   gui-apps.hexchat = enabled;
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
  system.stateVersion = "23.05";
}
