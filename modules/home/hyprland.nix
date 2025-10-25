{ config, ...}: {
  flake.homeModules.hyprland =
  {
    imports = with config.flake.homeModules; [
      kitty
    ];
    home.sessionVariables.NIXOS_OZONE_WL = "1";
    wayland.windowManager.hyprland.enable = true;
  };
}
