{
  inputs,
  self,
  ...
}:
{
  flake.homeModules.base = {
    imports =
      (with self.homeModules; [
        ironman
      ])
      ++ (with inputs; [
        nix-flatpak.homeManagerModules.nix-flatpak
        noctalia.homeModules.default
        plasma-manager.homeModules.plasma-manager
      ]);
  };
}
