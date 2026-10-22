{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.sonarqube = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      docker
      proxmox
      server
      sonarqube
    ];
  };
}
