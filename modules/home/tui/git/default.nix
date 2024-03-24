{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) enabled mkBoolOpt;

  cfg = config.mine.home.tui.git;
  configFolder = "${config.xdg.configHome}/lazygit";
  imp = config.mine.home.impermanence.enable;
  os = osConfig.mine.tui.git;
in {
  options.mine.home.tui.git = {
    enable = mkBoolOpt os.enable "Setup git";
  };

  config = mkIf cfg.enable {
    home = {
      persistence."/persist/home".files = mkIf imp [
        ".config/lazygit/state.yml"
      ];
      sessionVariables = {
        LG_CONFIG_FILE = "${configFolder}/config.yml,${configFolder}/themes/mocha/red.yml";
      };
      shellAliases = {
        lg = "lazygit";
      };
    };
    programs = {
      gh = {
        inherit (cfg) enable;
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
        diff-so-fancy = enabled;
        enable = true;
        extraConfig = {
          feature.manyFiles = true;
          init.defaultBranch = "main";
          gpg.format = "ssh";
          merge.tool = "vimdiff";
        };
        ignores = [".direnv" "result"];
        lfs = enabled;
        signing = {
          key = "~/.ssh/github";
          signByDefault = true;
        };
        userName = config.mine.home.user.fullName;
        userEmail = config.mine.home.user.email;
      };
    };
    xdg.configFile = {
      "lazygit/config.yml".source = ./lazygit.yml;
      "lazygit/themes".source = pkgs.catppuccin-lazygit;
    };
  };
}
