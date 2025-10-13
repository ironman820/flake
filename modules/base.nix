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
        de-plasma
        default-system
        drive-shares
        firmware
        gpg
        ironman
        sddm
        sops
        (modulesPath + "/installer/scan/not-detected.nix")
      ];
    };
}
