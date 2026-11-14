{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.traefik = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      lazylibrarian
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
