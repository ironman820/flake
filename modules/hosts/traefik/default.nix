{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.traefik = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      lidarr
      navidrome
      proxmox
      server
      slskd
      traefik
    ];
  };
}
