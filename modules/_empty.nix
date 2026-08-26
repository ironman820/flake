{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake = {
    nixosModules.NAME = moduleWithSystem (
      perSystem@{ ... }:
      _: {
      }
    );
    homeModules.NAME = moduleWithSystem (
      perSystem@{ ... }:
      _: {
      }
    );
  };
  perSystem =
    {
      # config,
      self',
      # inputs',
      pkgs,
      # system,
      ...
    }:
    {
      apps.NAME = {
        meta.description = "";
        program = self'.packages.NAME;
      };
      packages.NAME = inputs.wrappers.lib.wrapPackage (_: {
        inherit pkgs;
        package = pkgs.NAME;
      });
    };
}
