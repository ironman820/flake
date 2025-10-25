{ config, ... }:
{
  flake.homeModules.hyprland = {
    imports = with config.flake.homeModules; [
      hyprland-config
    ];
  };
}
