{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.gns3-work = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      docker
      gns3
      networkManager
      server
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.llama-work
    ];
  };
}
