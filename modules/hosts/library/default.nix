{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.library = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      bookorbit
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.library
      libraryConfig
      proxmox
      server
      VM
    ];
  };
}
