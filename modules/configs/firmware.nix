{ moduleWithSystem, ... }: {
  flake.nixosModules.firmware = moduleWithSystem (
    perSystem@{ inputs', ... }:
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        inputs'.stable.legacyPackages.firmware-manager
        gnome-firmware
      ];
      services.fwupd.enable = true;
    }
  );
}
