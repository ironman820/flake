{lib, ...}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    ./hardware.nix
  ];

  config = {
    mine = {
      suites.laptop = enabled;
    };
    system.stateVersion = "23.05";
    zramSwap = {
      enable = true;
      memoryPercent = 90;
    };
  };
}
