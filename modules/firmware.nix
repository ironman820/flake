{
  flake.nixosModules.firmware =
    {
      inputs,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        inputs.stable.legacyPackages.${pkgs.system}.firmware-manager
        gnome-firmware
      ];
      services.fwupd.enable = true;
    };
}
