{ self, inputs, ... }:
{
  flake.homeModules.hyprland = {
    imports = with self.homeModules; [
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
