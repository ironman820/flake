{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.mymusic = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.mymusic
      mymusicConfig
      navidrome
      proxmox
      server
      smbShares
      staticIP
      VM
    ];
  };
}
