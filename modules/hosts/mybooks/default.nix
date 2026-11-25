{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.mybooks = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      bookorbit
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.mybooks
      mybooksConfig
      proxmox
      server
      staticIP
      VM
    ];
  };
}
