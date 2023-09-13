{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware.nix
    ../stylix.nix
  ];

  config = {
    ironman = {
      home.extraOptions = {
        home.file.".config/is_personal".text = ''true'';
        programs.git.signing = {
          key = "~/.ssh/github_home";
          signByDefault = builtins.stringLength "~/.ssh/github_home" > 0;
        };
      };
      personal-apps.enable = true;
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
