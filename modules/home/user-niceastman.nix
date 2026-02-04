{ config, inputs, ... }:
{
  flake.homeConfigurations.niceastman =
    { pkgs, ... }:
    {
      imports = with config.flake.homeModules; [
        base
        flatpak
        kitty
        llama-work-sops
        plasma
        inputs.plasma-manager.homeModules.plasma-manager
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
