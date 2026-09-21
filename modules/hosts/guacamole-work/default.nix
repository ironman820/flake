{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.guacamole-work = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      guacamole
      guacamoleWorkConfig
      networkManager
      server
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.guacamoleWork
    ];
  };
}
