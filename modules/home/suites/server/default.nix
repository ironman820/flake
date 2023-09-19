{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.home.suites.server;
in
{
  options.ironman.home.suites.server = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
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
}
