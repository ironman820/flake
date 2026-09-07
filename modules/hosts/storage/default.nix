{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.storage = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      storageConfig
      copyparty
      proxmox
      server
    ];
  };
}
