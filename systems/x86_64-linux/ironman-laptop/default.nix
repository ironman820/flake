{ pkgs, config, lib, ... }:
let
  inherit (lib.ironman) enabled;
in
{
  imports = [
    ./hardware.nix
    ../stylix.nix
  ];

  config = {
    ironman = {
      suites.laptop = enabled;
    };
    stylix.image = ./scream.jpg;
    system.stateVersion = "23.05";
    zramSwap = {
      enable = true;
      memoryPercent = 90;
    };
  };
}
