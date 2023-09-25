{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware.nix
    ./networking.nix
  ];

  config = {
    ironman = {
      nix.gc = {
        dates = "03:15";
        options = "--delete-older-than 1d";
      };
      suites.server.enable = true;
      servers.dns = {
        auth = true;
        enable = true;
        recursor.forwards = {
          "niceastman.com" = "127.0.0.1:5300";
          "home.niceastman.com" = "127.0.0.1:5300";
          "desk.niceastman.com" = "192.168.20.2";
        };
      };
    };
    system.stateVersion = "23.05";
  };
}
