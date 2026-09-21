{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.vaultwarden = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      proxmox
      server
    ];
  };
}
