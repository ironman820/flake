{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.soulsync = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      proxmox
      server
      soulsync
      soulsyncConfig
      syncthing
    ];
  };
}
