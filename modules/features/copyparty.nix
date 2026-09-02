{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake = {
    nixosModules.copyparty = moduleWithSystem (
      perSystem@{ ... }:
      _: {
        imports = [
          inputs.copyparty.nixosModules.default
        ];
        services.copyparty.enable = true;
      }
    );
    homeModules.copyparty = moduleWithSystem (
      perSystem@{ ... }:
      _: {
      }
    );
  };
}
