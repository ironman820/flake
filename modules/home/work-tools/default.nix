{ options, pkgs, config, lib, inputs, ... }:

with lib;
with lib.ironman;
# with lib.internal;
let
  cfg = config.ironman.home.work-tools;
in
{
  options.ironman.home.work-tools = with types; {
    enable = mkBoolOpt false "Enable the Work Machine Tools";
  };

  config = mkIf cfg.enable {
    home = {
      packages = (with pkgs; [
        barrier
        dia
        # glocom
        qgis
        teams
        thunderbird
        wireshark
        zoom-us
      ]);
    };
    programs = {
      git = {
        signing = {
          key = "~/.ssh/github_work";
          signByDefault = builtins.stringLength "~/.ssh/github_work" > 0;
        };
        userName = config.ironman.home.user.fullName;
        userEmail = config.ironman.home.user.email;
      };
    };
  };
}
