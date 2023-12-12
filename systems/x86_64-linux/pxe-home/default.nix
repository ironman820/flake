{ lib, ... }:
let inherit (lib.ironman) enabled;
in {
  imports = [
    ./hardware.nix
    ./networking.nix
  ];

  config = {
    ironman = {
      servers.pxe = {
        enable = true;
        netboot = true;
        nix = false;
      };
      suites.server = enabled;
      virtual.guest = enabled;
    };

    system.stateVersion = "23.05";
  };
}
