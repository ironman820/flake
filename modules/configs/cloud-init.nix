{
  flake.nixosModules.cloud-init = {
    services.cloud-init = {
      enable = true;
      network.enable = true;
    };
  };
}
