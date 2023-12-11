{ lib, pkgs, ... }:
with lib;
with lib.ironman;
{
  imports = [
    ./hardware.nix
    ./networking.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      openssl
    ];
    ironman = {
      suites.server = {
        enable = true;
        rcm2 = enabled;
      };
      virtual.guest.enable = true;
    };

    system.stateVersion = "23.05";
  };

}
