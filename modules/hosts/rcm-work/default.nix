{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.rcm-work = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      proxmox
      server
    ];
  };
}
