{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware.nix
  ];

  config = {
    ironman = {
      home.extraOptions.home.file.".config/is_personal".text = ''false'';
      nix.gc = {
        dates = "03:15";
        options = "--delete-older-than 1d";
      };
      suites.server.enable = true;
    };
    system.stateVersion = "23.05";
  };
}
