{ pkgs, config, ... }:
{
  imports = [
    ./hardware.nix
    ../stylix.nix
  ];

  config = {
    ironman = {
      home.extraOptions.home.file.".config/is_personal".text = ''false'';
      suites.laptop.enable = true;
      user.name = "niceastman";
      work-tools.enable = true;
      virtual.podman.enable = true;
      wireless-profiles.work = true;
    };
    stylix.image = ./voidbringer.png;
    system.stateVersion = "23.05";
  };
}
