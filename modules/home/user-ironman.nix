{ config, ... }:
{
  flake.homeConfigurations.ironman = {
    imports = with config.flake.homeModules; [
      base
      extra
      flatpak
      kitty
      llama-work-sops
      qt
      syncthing
    ];
  };
}
