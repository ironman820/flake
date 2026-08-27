{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.friday = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      arduino
      fridayConfig
      laptop
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.friday
    ];
  };
}
