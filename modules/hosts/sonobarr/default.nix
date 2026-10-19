{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.sonobarr = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      docker
      sonobarr
      proxmox
      server
    ];
  };
}
