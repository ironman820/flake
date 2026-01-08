{
  flake.nixosModules.syncthing = {
    services.syncthing.openDefaultPorts = true;
  };
}
