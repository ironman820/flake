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
    networking.firewall.enable = false;
    security.sudo.wheelNeedsPassword = false;
  };
}
