{ config, ... }:
{
  flake.homeConfigurations.ironman-server = {
    imports = with config.flake.homeModules; [
      base
    ];
  };
}
