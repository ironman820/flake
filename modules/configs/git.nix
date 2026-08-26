{
  self,
  ...
}:
{
  flake = {
    nixosModules.git = { lib, pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        git-extras
        git-filter-repo
        github-cli
      ];
      programs.git = {
        enable = true;
        prompt.enable = lib.mkDefault true;
      };
    };
    homeModules.git =
      {
        config,
        osConfig,
        lib,
        pkgs,
        ...
      }:
      let
        os = osConfig.ironman.user;
      in
      {
        home = {
          sessionVariables.GH_TOKEN = "$(${lib.getExe' pkgs.coreutils "cat"} ${config.sops.secrets.github_token.path})";
          shellAliases = {
            lg = "lazygit";
          };
        };
        programs = {
          delta = {
            enable = true;
            enableGitIntegration = true;
            options = {
              minus-style = ''syntax "#4a272f"'';
              minus-non-emph-style = ''syntax "#4a272f"'';
              minus-emph-style = ''syntax "#713137"'';
              minus-empty-line-marker-style = ''syntax "#4a272f"'';
              line-numbers-minus-style = ''"#914c54"'';
              plus-style = ''syntax "#243e4a"'';
              plus-non-emph-style = ''syntax "#243e4a"'';
              plus-emph-style = ''syntax "#2c5a66"'';
              plus-empty-line-marker-style = ''syntax "#243e4a"'';
              line-numbers-plus-style = ''"#449dab"'';
              line-numbers-zero-style = ''"#3b4261"'';
            };
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
              alias.graph = "log --decorate --oneline --graph";
              commit.gpgSign = true;
              feature.manyFiles = true;
              init.defaultBranch = "main";
              gpg.format = "ssh";
              merge = {
                guitool = "vimdiff";
                tool = "vimdiff";
              };
              user = {
                email = "29488820+ironman820@users.noreply.github.com";
                name = os.fullName;
                signingKey = config.sops.secrets.github.path;
              };
            };
          };
          lazygit = {
            enable = true;
            enableBashIntegration = true;
            settings = {
              disableStartupPopups = true;
              git.diffRenderers = [
                "delta --paging=never"
              ];
              gui = {
                nerdFontsVersion = 3;
                showCommandLog = false;
                theme = {
                  activeBorderColor = [
                    "#ff9e64"
                    "bold"
                  ];
                  inactiveBorderColor = [
                    "#27a1b9"
                  ];
                  searchingActiveBorderColor = [
                    "#ff9e64"
                    "bold"
                  ];
                  optionsTextColor = [
                    "#7aa2f7"
                  ];
                  selectedLineBgColor = [
                    "#283457"
                  ];
                  cherryPickedCommitFgColor = [
                    "#7aa2f7"
                  ];
                  cherryPickedCommitBgColor = [
                    "#bb9af7"
                  ];
                  markedBaseCommitFgColor = [
                    "#7aa2f7"
                  ];
                  markedBaseCommitBgColor = [
                    "#e0af68"
                  ];
                  unstagedChangesColor = [
                    "#db4b4b"
                  ];
                  defaultFgColor = [
                    "#c0caf5"
                  ];
                };
              };
              promptToReturnFromSubprocess = false;
            };
          };
        };
        sops.secrets.github_token.sopsFile = "${self.outPath}/.secrets/git.yaml";
      };
  };
}
