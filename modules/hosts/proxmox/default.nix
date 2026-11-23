{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.proxmox = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      proxmox
      proxmoxLXC
      server
    ];
  };
}
