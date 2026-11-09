{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.lazylibrarian = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      docker
      lazylibrarian
      proxmox
      server
    ];
  };
}
