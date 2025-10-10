{ config, ... }:
{
  flake.nixosModules.base =
    {
      lib,
      modulesPath,
      ...
    }:
    {
      imports = with config.flake.nixosModules; [
        apps-base
        boot-grub
        drive-shares
        ironman
        sops
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      networking.useDHCP = lib.mkDefault true;
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      system.stateVersion = "25.05";
    };
}
