{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware.nix
  ];

  config = {
    ironman = {
      suites.server.enable = true;
      virtual.guest.enable = true;
    };
    system.stateVersion = "23.05";
  };
}