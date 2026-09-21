{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.vaultwarden = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      proxmox
      server
      vaultwardenConfig
    ];
  };
}
