{ inputs, self, ... }:
{
  flake.nixosModules.base =
    {
      imports = (with inputs; [
        niri.nixosModules.niri
        nix-topology.nixosModules.default
        noctalia.nixosModules.default
        noctalia-greeter.nixosModules.default
      ]) ++ (with self.nixosModules; [
        ironman
      ]);
    };
}
