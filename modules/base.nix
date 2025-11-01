{ config, ... }:
{
  flake.nixosModules.base = _: {
    imports = with config.flake.nixosModules; [
      apps-base
      default-system
      ironman
      ssh
      sops
    ];
  };
}
