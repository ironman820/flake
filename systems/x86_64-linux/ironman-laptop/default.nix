{ pkgs, config, lib, ... }:
{
  imports = [
    ./hardware.nix
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
      suites.laptop.enable = true;
      vitual.podman.enable = true;
    };
    system.stateVersion = "23.05";
  };
}
