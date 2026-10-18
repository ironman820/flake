{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.traefik = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      aurral
      lidarr
      navidrome
      proxmox
      server
      slskd
      traefik
    ];
  };
}
