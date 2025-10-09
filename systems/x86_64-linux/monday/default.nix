{lib, ...}: {
  imports = [
    ./hardware.nix
    (import ../../disko.nix {
      bootSize = "128M";
      device = "/dev/sda";
      swapSize = "2G";
    })
  ];

  config = let
    inherit (lib.mine) enabled;
  in {
    mine = {
      suites.laptop = enabled;
    };
    system.stateVersion = "23.05";
  };
}
