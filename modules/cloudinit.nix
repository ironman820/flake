{
  flake.nixosModules.cloud-init = {
    networking.useDHCP = false;
    services.cloud-init = {
      network.enable = true;
    };
  };
}
