{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.library = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      bookkeep
      docker
      libraryConfig
      proxmox
      server
    ];
  };
}
