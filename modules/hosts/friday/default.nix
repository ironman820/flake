{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.friday = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      arduino
      laptop
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.friday
    ];
  };
}
