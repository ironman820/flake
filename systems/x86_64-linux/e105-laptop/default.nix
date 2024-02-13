{lib, ...}: let
  inherit (lib.mine) enabled;
in {
  imports = [./hardware.nix];

  config = {
    mine = {
      android = enabled;
      configurations.autofs = enabled;
      suites.laptop = enabled;
      user.name = "niceastman";
      work-tools = enabled;
      wireless-profiles.work = true;
    };
    system.stateVersion = "23.05";
  };
}
