{ pkgs, config, lib, ... }:
let
  inherit (lib.ironman) enabled;
in
{
  imports = [
    ./hardware.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      glocom
    ];
    ironman = {
      suites.laptop = enabled;
    };
    system.stateVersion = "23.05";
    zramSwap = {
      enable = true;
      memoryPercent = 90;
    };
  };
}
