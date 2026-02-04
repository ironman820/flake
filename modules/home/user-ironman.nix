{ config, inputs, ... }:
{
  flake.homeConfigurations.ironman = {
    imports = with config.flake.homeModules; [
      base
      extra
      flatpak
      kitty
      llama-work-sops
      plasma
      inputs.plasma-manager.homeModules.plasma-manager
      qt
      syncthing
    ];
  };
}
