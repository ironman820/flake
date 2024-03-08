_: {
  imports = [
    ./hardware.nix
    ../../../common/drives/personal.nix
  ];

  config = {
    mine = {
      suites.virtual-workstation.enable = true;
    };
    system.stateVersion = "23.05";
  };
}
