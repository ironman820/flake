{ config, inputs, lib, pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./networking.nix
  ];

  config = with lib; {
    environment.systemPackages = with pkgs; [
      openssl
    ];
    ironman = {
      suites.server = {
        enable = true;
        rcm2.enable = false;
      };
      virtual.guest.enable = true;
    };

    system.stateVersion = "23.05";
  };

}
