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
      proxmox
      proxmoxLXC
      server
    ];
  };
}
