{ config, ... }:
{
  flake.nixosModules.laptop = _: {
    imports = with config.flake.nixosModules; [
      apps-gui
      de-plasma
      drive-shares
      gpg
      power
      sddm
      sound
      yubikey
    ];
  };
}
