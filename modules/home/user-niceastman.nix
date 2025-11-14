{ config, ... }:
{
  flake.homeConfigurations.niceastman =
    { pkgs, ... }:
    {
      imports = with config.flake.homeModules; [
        base
        flatpak
        kitty
        llama-work-sops
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
