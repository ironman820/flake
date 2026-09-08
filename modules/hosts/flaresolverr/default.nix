{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.flaresolverr = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      proxmox
      server
    ];
  };
}
