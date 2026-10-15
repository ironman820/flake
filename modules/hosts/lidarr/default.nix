{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.lidarr = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      lidarr
      proxmox
      server
    ];
  };
}
