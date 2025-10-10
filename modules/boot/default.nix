{ config, ... }:
{
  flake.nixosModules.boot = {
    imports = [
      config.flake.nixosModules.boot-grub
    ];
  };
}
