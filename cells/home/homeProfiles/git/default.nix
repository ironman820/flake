{
  cell,
  config,
  inputs,
  pkgs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  configFolder = "${config.xdg.configHome}/lazygit";
  l = nixpkgs.lib // mine.lib // builtins;
  v = config.vars;
in {
  home = {
    sessionVariables = {
      LG_CONFIG_FILE = "${configFolder}/config.yml";
    };
    shellAliases = {
      lg = "lazygit";
    };
  };
  programs = {
    gh = {
      enable = true;
      settings = {
        editor = "nvim";
        git_protocol = "ssh";
      };
    };
    git = {
      aliases = {
        pushall = "!git remote | xargs -L1 git push --all";
        graph = "log --decorate --oneline --graph";
        add-nowhitespace = "!git diff -U0 -w --no-color | git apply --cached --ignore-whitespace --undiff-zero -";
      };
      diff-so-fancy = l.enabled;
      enable = true;
      extraConfig = {
        feature.manyFiles = true;
        init.defaultBranch = "main";
        gpg.format = "ssh";
        merge.tool = "vimdiff";
      };
      ignores = [".direnv" "result"];
      lfs = l.enabled;
      signing = {
        key = "~/.ssh/github";
        signByDefault = true;
      };
      userName = v.fullName;
      userEmail = v.email;
    };
  };
  xdg.configFile = {
    "lazygit/config.yml".source = ./__lazygit.yml;
    # "lazygit/themes".source = pkgs.catppuccin-lazygit;
  };
}
