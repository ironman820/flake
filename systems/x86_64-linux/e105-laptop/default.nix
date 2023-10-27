{ config, format, inputs, lib, pkgs, system, systems, target, virtual, ... }:
let
  inherit (lib.ironman) enabled;
in
{
  imports = [
    ./hardware.nix
  ];

  config = {
    ironman = {
      suites.laptop = enabled;
      user.name = "niceastman";
      work-tools = enabled;
      wireless-profiles.work = true;
    };
    system.stateVersion = "23.05";
  };
}
