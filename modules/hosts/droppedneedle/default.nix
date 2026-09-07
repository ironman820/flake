{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.droppedneedle = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      droppedneedle
      proxmox
      server
    ];
  };
}
