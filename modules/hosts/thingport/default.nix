{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.thingport = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      thingportConfig
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.thingport
      proxmox
      server
      staticIP
      thingport
      VM
    ];
  };
}
