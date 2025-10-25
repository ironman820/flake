{ config, ... }:
{
  flake.homeModules.hyprland = {
    imports = with config.flake.homeModules; [
      alacritty
      hypridle
      hyprland-config
      hyprlock
      mako
    ];
  };
}
