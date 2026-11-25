{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.traefik = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      bazarr
      kcc
      lidarr
      proxmox
      proxmoxLXC
      radarr
      rcm
      server
      slskd
      sonobarr
      sonarqube
      traefik
    ];
  };
}
