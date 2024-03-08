{lib, ...}: let
  inherit (lib) mkForce;
in {
  imports = [
    ./hardware.nix
    ../../../common/drives/personal.nix
  ];

  config = {
    mine = {
      hyprland.enable = mkForce false;
      suites.virtual-workstation.enable = true;
    };
    system.stateVersion = "23.05";
  };
}
