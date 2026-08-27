{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.calibre = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      calibreConfig
      proxmox
      server
    ];
  };
}
