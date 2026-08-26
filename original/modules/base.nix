{ inputs, self, ... }:
{
  flake.nixosModules.base =
    {
      imports = (with inputs; [
        disko.nixosModules.disko
        niri.nixosModules.niri
        nix-topology.nixosModules.default
        noctalia.nixosModules.default
        noctalia-greeter.nixosModules.default
      ]) ++ (with self.nixosModules; [
        git
        ironman
        nix
        tmux
      ]);
    };
}
