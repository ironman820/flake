{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.monday = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      inputs.disko.nixosModules.disko
      netbook
      networkProfiles
      self.diskoConfigurations.monday
    ];
  };
}
