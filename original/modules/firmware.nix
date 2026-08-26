{ inputs, ... }: {
  flake.nixosModules.firmware =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        inputs.stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.firmware-manager
        gnome-firmware
      ];
      services.fwupd.enable = true;
    };
}
