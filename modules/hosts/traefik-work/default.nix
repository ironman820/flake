{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.traefik-work = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      guacamole
      traefikWorkConfig
      proxmox
      server
    ];
  };
}
