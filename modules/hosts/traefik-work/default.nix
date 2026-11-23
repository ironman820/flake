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
      proxmoxLXC
      rcm
      rcm2
      server
    ];
  };
}
