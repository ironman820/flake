{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.guacamole-work = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      guacamole
      proxmox
      server
    ];
  };
}
