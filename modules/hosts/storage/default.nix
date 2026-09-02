{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.storage = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      copyparty
      proxmox
      server
    ];
  };
}
