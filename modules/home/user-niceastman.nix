{ config, ... }:
{
  flake.homeConfigurations.niceastman =
    { pkgs, ... }:
    {
      imports = with config.flake.homeModules; [
        base
        flatpak
        kitty
        qt
        syncthing
      ];
      home.packages = with pkgs; [
        qgis
        wireshark
        zoom-us
      ];
    };
}
