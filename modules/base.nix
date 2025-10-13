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
        boot-grub
        default-system
        firmware
        ironman
        sops
        (modulesPath + "/installer/scan/not-detected.nix")
      ];
    };
}
