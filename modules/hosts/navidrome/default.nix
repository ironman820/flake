{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.navidrome = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      navidrome
      proxmox
      server
    ];
  };
}
