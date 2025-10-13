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
        ironman
        ssh
        sops
        (modulesPath + "/installer/scan/not-detected.nix")
      ];
    };
}
