{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.soulsync = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      proxmox
      server
      soulsync
    ];
  };
}
