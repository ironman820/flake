{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.soulseek = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      proxmox
      server
      slskd
    ];
  };
}
