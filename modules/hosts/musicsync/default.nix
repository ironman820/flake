{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.musicsync = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.musicsync
      proxmox
      server
      smbShares
      smsync
      staticIP
      VM
    ];
  };
}
