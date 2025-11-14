{ config, ... }:
{
  flake.homeConfigurations.ironman-minimal = {
    imports = with config.flake.homeModules; [
      base
      flatpak
      kitty
    ];
  };
}
