{ config, format, home, host, inputs, lib, pkgs, systems, target, virtual, ...}:
with lib;
with lib.ironman;
{
  home.file.".config/is_personal".text = ''false'';
  ironman.home = {
    personal-apps.enable = true;
    suites.workstation = enabled;
    user.name = config.snowfallorg.user.name;
  };
  programs.git.signing = {
    key = "~/.ssh/github_home";
    signByDefault = builtins.stringLength "~/.ssh/github_home" > 0;
  };
}
