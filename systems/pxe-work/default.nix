_: {
  imports = [
    ./hardware.nix
    ./networking.nix
  ];

  config = {
    mine = {
      servers.pxe = {
        enable = true;
      };
      suites.server.enable = true;
      virtual.guest.enable = true;
    };

    system.stateVersion = "23.05";
  };
}
