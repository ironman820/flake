{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.sonobarr = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      sonobarr
      proxmox
      server
    ];
  };
}
