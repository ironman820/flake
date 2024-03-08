_: {
  imports = [
    ./hardware.nix
    # ../../../common/drives/personal.nix
    (import ../../../common/disko-tiny.nix {device = "";})
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
