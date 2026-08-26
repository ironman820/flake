{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.NAME = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      # core
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.NAME
    ];
  };
}
