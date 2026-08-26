{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake = {
    nixosModules.core = moduleWithSystem (
      perSystem@{ ... }:
      _: {
        imports =
          (with inputs; [ ])
          ++ (with self.nixosModules; [
            boot
          ]);
      }
    );
    homeModules.core = moduleWithSystem (
      perSystem@{ ... }:
      _: {
      }
    );
  };
}
