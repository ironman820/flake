{
  inputs,
  lib,
  self,
  ...
}:
{
  flake.nixosConfigurations.server-iso = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      iso
      proxmox
      server
      VM
      {
        boot.zfs.forceImportRoot = false;
        services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
      }
    ];
  };
}
