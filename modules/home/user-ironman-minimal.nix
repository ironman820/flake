{ config, inputs, ... }:
{
  flake.homeConfigurations.ironman-minimal = {
    imports = with config.flake.homeModules; [
      base
      flatpak
      kitty
      inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ];
  };
}
