{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.traefik = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      kcc
      lidarr
      proxmox
      proxmoxLXC
      radarr
      rcm
      server
      sonobarr
      sonarqube
      traefik
    ];
  };
}
