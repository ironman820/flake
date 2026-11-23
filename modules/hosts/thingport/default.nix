{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.thingport = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.thingport
      proxmox
      server
      VM
    ];
  };
}
