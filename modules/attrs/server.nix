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
    security.sudo.wheelNeedsPassword = false;
  };
}
