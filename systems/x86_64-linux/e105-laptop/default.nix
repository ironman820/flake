{lib, ...}: let
  inherit (lib.mine) enabled;
in {
  imports = [./hardware.nix];

  config = {
    mine = {
      android = enabled;
      drives.autofs = enabled;
      podman = enabled;
      stylix = {
        enable = true;
        image = ./voidbringer.png;
      };
      suites.laptop = enabled;
      user.name = "niceastman";
      work-tools = enabled;
      wireless-profiles.work = true;
    };
    system.stateVersion = "23.05";
  };
}
