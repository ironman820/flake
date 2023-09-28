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
    ironman.home.sops.secrets = {
      github_servers = {
        mode = "0400";
        path = "/home/${config.snowfallorg.user.name}/.ssh/github";
        sopsFile = ./secrets/github_servers.age;
      };
    };
    home.file.".config/is_server".text = ''true'';
    programs = {
      git.signing = {
        key = "~/.ssh/github";
        signByDefault = builtins.stringLength "~/.ssh/github" > 0;
      };
    };
  };
}
