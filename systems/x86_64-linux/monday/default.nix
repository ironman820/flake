_: {
  imports = [
    ./hardware.nix
    ../../../common/drives/personal.nix
    ../../../common/disko-tiny.nix
  ];

  config = {
    mine = {
      suites.laptop.enable = true;
    };
    system.stateVersion = "23.05";
    zramSwap = {
      enable = true;
      memoryPercent = 90;
    };
  };
}
