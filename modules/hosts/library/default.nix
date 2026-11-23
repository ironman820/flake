{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.library = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      bookorbit
      libraryConfig
      proxmox
      proxmoxLXC
      server
    ];
  };
}
