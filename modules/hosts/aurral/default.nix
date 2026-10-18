{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.aurral = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      ./_config.nix
      aurral
      proxmox
      server
    ];
  };
}
