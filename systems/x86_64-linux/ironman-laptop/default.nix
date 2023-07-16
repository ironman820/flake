{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware.nix
  ];

  config = {
    ironman = {
      home.extraOptions.programs.git.signing = {
        key = "~/.ssh/github_home";
        signByDefault = builtins.stringLength "~/.ssh/github_home" > 0;
      };
      suites.laptop.enable = true;
    };
    system.stateVersion = "23.05";
  };
}
