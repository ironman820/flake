{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware.nix
  ];

  system.stateVersion = "23.05";
}