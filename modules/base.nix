{ config, ... }:
{
  flake.nixosModules.base =
    {
      modulesPath,
      ...
    }:
    {
      imports = with config.flake.nixosModules; [
        apps-base
        default-system
        ironman
        ssh
        sops
      ];
    };
}
