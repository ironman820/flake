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
      lidarr
      navidrome
      proxmox
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
