{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.traefik-work = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      # core
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.traefik-work
    ];
  };
}
