{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.storage = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      storageConfig
      syncthing
      copyparty
      proxmox
      server
    ];
  };
}
