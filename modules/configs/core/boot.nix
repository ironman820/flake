{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake.nixosModules.boot = moduleWithSystem (
    perSystem@{ ... }:
    _: {
      boot = {
        kernelParams = [
          "quiet"
        ];
        loader = {
          efi.canTouchEfiVariables = true;
        };
      };
    }
  );
}
