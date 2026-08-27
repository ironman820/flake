{ inputs, self, ... }:
{
  flake.nixosModules.base =
    {
      imports = (with inputs; [
      ]) ++ (with self.nixosModules; [
        ironman
      ]);
    };
}
