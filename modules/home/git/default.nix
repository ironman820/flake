{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (lib) mkIf;
  inherit (lib.ironman) enabled mkBoolOpt;

  cfg = config.ironman.home.git;
in {
  options.ironman.home.git = {
    enable = mkBoolOpt true "Setup git";
  };

  config = mkIf cfg.enable {
    home = {
      file = {
        ".config/lazygit/config.yml".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/flake/modules/home/git/lazygit.yml";
      };
      packages = with pkgs; [
        git
        git-filter-repo
        github-cli
        glab
        lazygit
      ];
      shellAliases = {
        "lg" = "lazygit";
      };
    };
    programs.git = {
      aliases = {
        pushall = "!git remote | xargs -L1 git push --all";
        graph = "log --decorate --oneline --graph";
        add-nowhitespace = "!git diff -U0 -w --no-color | git apply --cached --ignore-whitespace --undiff-zero -";
      };
      diff-so-fancy = enabled;
      enable = true;
      extraConfig = {
        feature.manyFiles = true;
        init.defaultBranch = "main";
        gpg.format = "ssh";
      };
      ignores = [ ".direnv" "result" ];
      lfs = enabled;
      signing = {
        key = "~/.ssh/github";
        signByDefault = true;
      };
      userName = config.ironman.home.user.fullName;
      userEmail = config.ironman.home.user.email;
    };
  };
}
