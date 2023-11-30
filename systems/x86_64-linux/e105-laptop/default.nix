{ lib, ... }:
let inherit (lib.ironman) enabled;
in {
  imports = [ ./hardware.nix ];

  config = {
    ironman = {
      configurations.autofs = enabled;
      suites.laptop = enabled;
      user.name = "niceastman";
      work-tools = enabled;
      wireless-profiles.work = true;
    };
    system.stateVersion = "23.05";
  };
}
