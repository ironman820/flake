{ config, ... }:
{
  flake.homeModules.hyprland = {
    imports = with config.flake.homeModules; [
      hypridle
      hyprland-config
      hyprlock
    ];
  };
}
