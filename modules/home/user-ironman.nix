{config, ...}:
{
  flake.homeConfigurations.ironman = {
    imports = with config.flake.homeModules; [
      base
    ];
  };
}
