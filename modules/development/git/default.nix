{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.development.git;
in {
  options.ironman.development.git = with types; {
    enable = mkBoolOpt true "Whether or not to enable a desktop environment.";
  };

  config = mkIf cfg.enable {
    ironman.home.extraOptions = {
      programs.git = {
        aliases = {
          pushall = "!git remote | xargs -L1 git push --all";
          graph = "log --decorate --oneline --graph";
          add-nowhitespace = "!git diff -U0 -w --no-color | git apply --cached --ignore-whitespace --undiff-zero -";
        };
        enable = true;
        extraConfig = {
          feature.manyFiles = true;
          init.defaultBranch = "main";
          gpg.format = "ssh";
        };
        ignores = [ ".direnv" "result" ];
        lfs.enable = true;
        signing = {
          key = "~/.ssh/github_home";
          signByDefault = builtins.stringLength "~/.ssh/github_home" > 0;
        };
        userName = config.ironman.user.fullName;
        userEmail = config.ironman.user.email;
      };
    };
    programs.git = enabled;
  };
}