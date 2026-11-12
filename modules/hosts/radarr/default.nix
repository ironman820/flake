{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.radarr = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      proxmox
      radarr
      server
    ];
  };
}
