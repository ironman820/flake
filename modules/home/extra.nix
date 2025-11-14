{ config, ... }:
{
  flake.homeModules.extra = _: {
    imports = with config.flake.homeModules; [
      podman
      yubikey
    ];
  };
}
