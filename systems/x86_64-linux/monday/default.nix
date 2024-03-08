{lib, ...}: {
  imports = [
    ./hardware.nix
    # ../../../common/drives/personal.nix
    (import ../../../common/disko-tiny.nix {device = "";})
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
