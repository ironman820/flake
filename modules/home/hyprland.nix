{ config, inputs, ... }:
{
  flake.homeModules.hyprland = {
    imports = with config.flake.homeModules; [
      alacritty
      hypridle
      hyprland-config
      hyprlock
      mako
      omanix
      swayosd
      inputs.walker.homeManagerModules.default
      walker
      waybar
    ];
  };
}
