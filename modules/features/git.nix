{
  self,
  ...
}:
{
  flake = {
    nixosModules.git = { lib, ... }: {
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
          packages = with pkgs; [
            git-extras
            git-filter-repo
            github-cli
          ];
          sessionVariables.GH_TOKEN = "$(${lib.getExe' pkgs.coreutils "cat"} ${config.sops.secrets.github_token.path})";
          shellAliases = {
            lg = "lazygit";
          };
        };
        programs = {
          delta = {
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
                {
                  command = "delta --paging=never";
                }
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
