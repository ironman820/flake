{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware.nix
  ];

  config = {
    ironman.suites.server.enable = true;
    system.stateVersion = "23.05";
  };
}
