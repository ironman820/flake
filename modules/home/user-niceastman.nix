{ config, ... }:
{
  flake.homeConfigurations.niceastman =
    { pkgs, ... }:
    {
      imports = with config.flake.homeModules; [
        base
        flatpak
        hyprland
        kitty
        putty
      ];
      home.packages = with pkgs; [
        qgis
        wireshark
        zoom-us
      ];
    };
}
