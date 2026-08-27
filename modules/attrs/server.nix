{
  self,
  ...
}:
{
  flake.nixosModules.server = {
    imports = (
      with self.nixosModules;
      [
        core
      ]
    );
    ironman.grub = false;
    networking.firewall.enable = false;
    security.sudo.wheelNeedsPassword = false;
  };
}
