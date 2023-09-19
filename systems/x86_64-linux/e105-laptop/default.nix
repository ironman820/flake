{ config, format, inputs, lib, pkgs, system, systems, target, virtual, ... }:
with lib;
with lib.ironman;
{
  imports = [
    ./hardware.nix
    ../stylix.nix
  ];

  config = {
    ironman = {
      suites.laptop = enabled;
      user.name = "niceastman";
      work-tools = enabled;
      virtual.podman = enabled;
      wireless-profiles.work = true;
    };
    stylix.image = ./voidbringer.png;
    system.stateVersion = "23.05";
  };
}
