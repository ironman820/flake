{ config, inputs, ... }:
{
  flake.homeConfigurations.ironman = {
    imports =
      (with config.flake.homeModules; [
        base
        extra
        flatpak
        python
        qt
        syncthing
      ])
      ++ (with inputs; [
        nix-flatpak.homeManagerModules.nix-flatpak
      ]);
  };
}
