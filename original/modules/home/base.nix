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
        plasma-manager.homeModules.plasma-manager
      ]);
  };
}
