_: {
  imports = [
    ./hardware.nix
  ];

  config = {
    mine = {
      suites.virtual-workstation.enable = true;
    };
    system.stateVersion = "23.05";
  };
}
