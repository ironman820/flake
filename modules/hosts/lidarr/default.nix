{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.NAME = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      lidarr
      proxmox
      server
    ];
  };
}
