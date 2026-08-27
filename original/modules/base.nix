{ inputs, self, ... }:
{
  flake.nixosModules.base =
    {
      imports = (with inputs; [
        nix-topology.nixosModules.default
        noctalia-greeter.nixosModules.default
      ]) ++ (with self.nixosModules; [
        ironman
      ]);
    };
}
