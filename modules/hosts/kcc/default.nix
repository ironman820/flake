{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.kcc = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      kcc
      proxmox
      server
    ];
  };
}
