{lib, ...}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    ./hardware.nix
    ../../../common/drives/work.nix
    ../../../common/drives/personal.nix
  ];

  config = {
    mine = {
      android = enabled;
      user.settings.stylix.image = ./voidbringer.png;
      podman = enabled;
      suites.laptop = enabled;
      user.name = "niceastman";
      work-tools = enabled;
      wireless-profiles.work = true;
    };
    system.stateVersion = "23.05";
  };
}
