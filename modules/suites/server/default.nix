{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.suites.server;
in {
  options.ironman.suites.server = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    ironman = {
      home.extraOptions = {
        home.file = {
          ".config/is_server".text = ''true'';
        };
        programs = {
          git.signing = {
            key = "~/.ssh/github_servers";
            signByDefault = builtins.stringLength "~/.ssh/github_servers" > 0;
          };
        };
      };
    };
    security.sudo.wheelNeedsPassword = false;
  };
}
