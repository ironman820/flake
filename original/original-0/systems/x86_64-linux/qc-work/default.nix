_: {
  imports = [
    ./hardware.nix
    ./networking.nix
  ];

  boot.kernel.sysctl = {
    "vm.max_map_count" = 524288;
    "fs.file-max" = 131072;
  };
  mine = {
    servers.sonarqube.enable = true;
    suites.server.enable = true;
    virtual.guest.enable = true;
  };
  system.stateVersion = "23.05";
}
