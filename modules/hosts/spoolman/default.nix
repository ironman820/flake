{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.spoolman = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.spoolman
      proxmox
      server
      smbShares
      spoolman
      staticIP
      VM
    ];
  };
}
