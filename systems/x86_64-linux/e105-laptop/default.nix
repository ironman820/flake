{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware.nix
  ];

  config = {
    ironman = {
      home.extraOptions.home.file.".config/is_personal".text = ''false'';
      suites.laptop.enable = true;
      user.name = "niceastman";
      work-laptop.enable = true;
      virtual.podman.enable = true;
      wireless-profiles.work = true;
    };
    system.stateVersion = "23.05";
  };
}
