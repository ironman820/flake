{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.traefik-work = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      guacamole
      traefik
      traefikWorkConfig
      proxmox
      rcm
      rcm2
      server
    ];
  };
}
