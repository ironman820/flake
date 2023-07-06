{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware.nix
  ];

  config = {
    ironman.suites.laptop.enable = true;
    system.stateVersion = "23.05";
  };
}
