{config, ...}:
{
  flake.homeConfigurations.user-ironman = {
    imports = with config.flake.homeModules; [
      base
    ];
  };
}
