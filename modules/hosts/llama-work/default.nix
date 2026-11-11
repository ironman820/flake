{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.llama-work = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      docker
      # gns3
      llamaWorkConfig
      networkManager
      server
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.llama-work
    ];
  };
}
