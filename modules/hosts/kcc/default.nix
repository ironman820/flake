{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.kcc = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.kcc
      docker
      kcc
      proxmox
      server
      smbShares
      staticIP
      VM
    ];
  };
}
