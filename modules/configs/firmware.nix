{ moduleWithSystem, ... }: {
  flake.nixosModules.firmware = moduleWithSystem (
    perSystem@{ inputs', ... }:
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        inputs'.stable.legacyPackages.firmware-manager
        pkgs.gnome-firmware
      ];
      services.fwupd.enable = true;
    }
  );
}
