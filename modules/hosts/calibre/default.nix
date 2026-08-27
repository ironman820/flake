{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.calibre = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      proxmox
      server
    ];
  };
}
