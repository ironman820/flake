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
      navidrome
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
