{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware.nix
    ../stylix.nix
  ];

  config = {
    ironman = {
      suites.laptop.enable = true;
      virtual.podman.enable = true;
    };
    stylix.image = ./girl-mech.png;
    system.stateVersion = "23.05";
    zramSwap = {
      enable = true;
      memoryPercent = 90;
    };
  };
}
