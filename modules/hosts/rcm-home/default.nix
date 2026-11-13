{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.rcm-home = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      proxmox
      rcm
      rcmHomeConfig
      server
    ];
  };
}
