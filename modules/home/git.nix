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
          LG_CONFIG_FILE = "${configFolder}/config.yml,${configFolder}/themes/tokyonight_night.yml";
        };
        shellAliases = {
          lg = "lazygit";
        };
      };
      programs = {
        diff-so-fancy = {
          enable = true;
          enableGitIntegration = true;
        };
        gh = {
          enable = true;
          settings = {
            editor = "nvim";
            git_protocol = "ssh";
          };
        };
        git = {
          enable = true;
          ignores = [
            ".direnv"
            "result"
          ];
          lfs.enable = true;
          settings = {
            aliases = {
              pushall = "!git remote | xargs -L1 git push --all";
              graph = "log --decorate --oneline --graph";
              add-nowhitespace = "!git diff -U0 -w --no-color | git apply --cached --ignore-whitespace --undiff-zero -";
            };
            feature.manyFiles = true;
            init.defaultBranch = "main";
            gpg.format = "ssh";
            merge.tool = "vimdiff";
            user = {
              email = "29488820+ironman820@users.noreply.github.com";
              name = os.fullName;
            };
          };
          signing = {
            key = "~/.ssh/github";
            signByDefault = true;
          };
        };
        lazygit.enable = true;
      };
      xdg.configFile = {
        "lazygit/config.yml".source = flakeRoot + "/.config/lazygit.yml";
        "lazygit/themes".source = pkgs.local.tokyonight-lazygit;
      };
    };
}
