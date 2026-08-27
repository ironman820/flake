{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.friday = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      arduino
      docker
      fridayConfig
      laptop
      virtualHost
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.friday
    ];
  };
}
