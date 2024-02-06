{lib, ...}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    ./hardware.nix
    ./networking.nix
  ];

  config = {
    mine = {
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
