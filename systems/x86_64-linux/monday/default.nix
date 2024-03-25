{lib, ...}: {
  imports = [
    ./hardware.nix
    (import ../../disko.nix {
      bootSize = "128M";
      device = "";
      swapSize = "2G";
    })
  ];

  config = let
    inherit (lib.mine) enabled;
  in {
    mine = {
      impermanence = enabled;
      suites.laptop = enabled;
    };
    system.stateVersion = "23.05";
    zramSwap = {
      enable = true;
      memoryPercent = 90;
    };
  };
}
