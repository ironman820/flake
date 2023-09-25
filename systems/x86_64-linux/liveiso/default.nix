{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware.nix
  ];

  config = {
    ironman = {
      nix.gc = {
        dates = "03:15";
        options = "--delete-older-than 1d";
      };
      suites.server.enable = true;
      user.name = "nixos";
    };
    system.stateVersion = "23.05";
  };
}
