{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.guacamole = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      guacamole
      proxmox
      server
    ];
  };
}
