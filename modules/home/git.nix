{
  flake.homeModules.git =
    {
      config,
      flakeRoot,
      osConfig,
      pkgs,
      ...
    }:
    let
      configFolder = "${config.xdg.configHome}/lazygit";
      os = osConfig.ironman.user;
    in
    {
      home = {
        sessionVariables = {
          LG_CONFIG_FILE = "${configFolder}/config.yml,${configFolder}/themes/mocha/mauve.yml";
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
          diff-so-fancy.enable = true;
          enable = true;
          extraConfig = {
            feature.manyFiles = true;
            init.defaultBranch = "main";
            gpg.format = "ssh";
            merge.tool = "vimdiff";
          };
          ignores = [
            ".direnv"
            "result"
          ];
          lfs.enable = true;
          signing = {
            key = "~/.ssh/github";
            signByDefault = true;
          };
          userName = os.fullName;
          userEmail = "29488820+ironman820@users.noreply.github.com";
        };
        lazygit.enable = true;
      };
      xdg.configFile = {
        "lazygit/config.yml".source = flakeRoot + "/.config/lazygit.yml";
        "lazygit/themes".source = pkgs.local.catppuccin-lazygit;
      };
    };
}
