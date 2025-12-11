{ config, ... }:
{
  flake.homeConfigurations.royell =
    _:
    {
      imports = with config.flake.homeModules; [
        base
      ];
    };
}
