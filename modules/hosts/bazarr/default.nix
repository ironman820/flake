{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.bazarr = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      bazarr
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.bazarr
      proxmox
      server
      smbShares
      staticIP
      VM
    ];
  };
}
