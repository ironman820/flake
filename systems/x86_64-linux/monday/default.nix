_: {
  imports = [
    ./hardware.nix
    (import ../../disko.nix {
      bootSize = "128M";
      device = "";
      swapSize = "2G";
    })
  ];

  config = {
    mine = {
      impermanence.enable = true;
      suites.laptop.enable = true;
    };
    system.stateVersion = "23.05";
    zramSwap = {
      enable = true;
      memoryPercent = 90;
    };
  };
}
