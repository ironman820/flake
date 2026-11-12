{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.rcm2-work = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      proxmox
      rcm2
      server
    ];
  };
}
