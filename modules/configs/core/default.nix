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
            fonts
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
