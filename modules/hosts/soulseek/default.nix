{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.soulseek = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.slsk
      proxmox
      server
      slskd
      slskConfig
      staticIP
      smbShares
      VM
    ];
  };
}
