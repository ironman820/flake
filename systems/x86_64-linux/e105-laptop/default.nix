{ config, format, inputs, lib, pkgs, system, systems, target, virtual, ... }:
let
  inherit (lib.ironman) enabled;
in
{
  imports = [
    ./hardware.nix
    ../stylix.nix
  ];

  config = {
    ironman = {
      sops.secrets.github.sopsFile = ./secrets/github_work.age;
      suites.laptop = enabled;
      user.name = "niceastman";
      work-tools = enabled;
      wireless-profiles.work = true;
    };
    stylix.image = ./voidbringer.png;
    system.stateVersion = "23.05";
  };
}
