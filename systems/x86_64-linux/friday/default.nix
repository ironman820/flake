{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    ./hardware.nix
    ./disko.nix
  ];
  config = {
    environment.systemPackages = with pkgs; [
      mmex
    ];
    mine.suites.laptop = enabled;
    system.stateVersion = "25.05";
  };
}
