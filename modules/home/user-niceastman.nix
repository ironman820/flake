{ config, ... }:
{
  flake.homeConfigurations.niceastman =
    { pkgs, ... }:
    {
      imports = with config.flake.homeModules; [
        base
      ];
      home.packages = with pkgs; [
        qgis
        wireshark
        zoom-us
      ];
    };
}
