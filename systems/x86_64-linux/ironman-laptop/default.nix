{lib, ...}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    (import ../../disko.nix
      {device = "/dev/nvme0n1";})
    ./hardware.nix
  ];

  config = {
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
