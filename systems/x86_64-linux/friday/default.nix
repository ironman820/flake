{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware.nix
  ];

  config = {
    ironman.suites.virtual-workstation.enable = true;
    system.stateVersion = "23.05";
  };
}
