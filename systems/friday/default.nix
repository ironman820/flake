{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware.nix
  ];

  config = {
    ironman = {
      home.extraOptions.home.file.".config/is_personal".text = ''true'';
      suites.virtual-workstation.enable = true;
    };
    system.stateVersion = "23.05";
  };
}
