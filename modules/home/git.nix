{
  flake.homeModules.git =
    {
      config,
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
        lazygit = {
          enable = true;
          settings = {
            gui = {
              screenMode = "normal";
              scrollHeight = 2;
              scrollPastBottom = true;
              scrollOffMargin = 2;
              scrollOffBehavior = "margin";
              sidePanelWidth = 0.3333;
              expandFocusedSidePanel = true;
              mainPanelSplitMode = "flexible";
              language = "auto";
              timeFormat = "2006-01-02";
              shortTimeFormat = "3:04PM";
              theme = {
                activeBorderColor = [
                  "green"
                  "bold"
                ];
                inactiveBorderColor = [
                  "white"
                ];
                searchingActiveBorderColor = [
                  "cyan"
                  "bold"
                ];
                optionsTextColor = [
                  "blue"
                ];
                selectedLineBgColor = [
                  "blue;"
                ];
                selectedRangeBgColor = [
                  "blue"
                ];
                cherryPickedCommitBgColor = [
                  "cyan"
                ];
                cherryPickedCommitFgColor = [
                  "blue"
                ];
                unstagedChangesColor = [
                  "red"
                ];
                defaultFgColor = [
                  "default"
                ];
              };
              commitLength.show = true;
              mouseEvents = false;
              skipDiscardChangeWarning = false;
              skipStashWarning = false;
              showFileTree = true;
              showListFooter = true;
              showRandomTip = true;
              showBranchCommitHash = false;
              showBottomLine = true;
              showPanelJumps = true;
              showCommandLog = true;
              showIcons = false;
              nerdFontsVersion = "3";
              commandLogSize = 8;
              splitDiff = "auto";
              skipRewordInEditorWarning = true;
              border = "rounded";
              animateExplosion = true;
              portraitMode = "auto";
            };
            git = {
              pagers = [
                {
                  colorArg = "always";
                  pager = "diff-so-fancy";
                }
              ];
              commit.signOff = false;
              merging = {
                manualCommit = true;
                args = "";
              };
              log = {
                order = "topo-order";
                showGraph = "when-maximised";
                showWholeGraph = false;
              };
              mainBranches = [
                "master"
                "main"
              ];
              autoFetch = true;
              autoRefresh = true;
              fetchAll = true;
              branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --";
              overrideGpg = false;
              disableForcePushing = false;
              parseEmoji = true;
              allBranchesLogCmds = [
                "git log --graph --all --color=always --abbrev-commit --decorate --date=relative  --pretty=medium"
              ];
            };
            os = {
              copyToClipboardCmd = "";
              editPreset = "nvim";
              edit = "";
              editAtLine = "";
              editAtLineAndWait = "";
              open = "";
              openLink = "";
            };
            refresher = {
              refreshInterval = 10;
              fetchInterval = 60;
            };
            update = {
              method = "never";
              days = 14;
            };
            confirmOnQuit = false;
            quitOnTopLevelReturn = false;
            disableStartupPopups = false;
            notARepository = "prompt";
            promptToReturnFromSubprocess = false;
            keybinding = {
              universal = {
                quit = "q";
                quit-alt1 = "<c-c>";
                return = "<esc>";
                quitWithoutChangingDirectory = "Q";
                togglePanel = "<tab>";
                prevItem = "<up>";
                nextItem = "<down>";
                prevItem-alt = "k";
                nextItem-alt = "j";
                prevPage = ",";
                nextPage = ".";
                gotoTop = "<";
                gotoBottom = ">";
                scrollLeft = "H";
                scrollRight = "L";
                prevBlock = "<left>";
                nextBlock = "<right>";
                prevBlock-alt = "h";
                nextBlock-alt = "l";
                jumpToBlock = [
                  "1"
                  "2"
                  "3"
                  "4"
                  "5"
                ];
                nextMatch = "n";
                prevMatch = "N";
                optionMenu = "<disabled>";
                optionMenu-alt1 = "?";
                select = "<space>";
                goInto = "<enter>";
                openRecentRepos = "<c-r>";
                confirm = "<enter>";
                remove = "d";
                new = "n";
                edit = "e";
                openFile = "o";
                scrollUpMain = "<pgup>";
                scrollDownMain = "<pgdown>";
                scrollUpMain-alt1 = "K";
                scrollDownMain-alt1 = "J";
                scrollUpMain-alt2 = "<c-u>";
                scrollDownMain-alt2 = "<c-d>";
                executeShellCommand = ":";
                createRebaseOptionsMenu = "m";
                pushFiles = "P";
                pullFiles = "p";
                refresh = "R";
                createPatchOptionsMenu = "<c-p>";
                nextTab = "]";
                prevTab = "[";
                nextScreenMode = "+";
                prevScreenMode = "_";
                undo = "z";
                redo = "<c-z>";
                filteringMenu = "<c-s>";
                diffingMenu = "W";
                diffingMenu-alt = "<c-e>";
                copyToClipboard = "<c-o>";
                submitEditorText = "<enter>";
                extrasMenu = "@";
                toggleWhitespaceInDiffView = "<c-w>";
                increaseContextInDiffView = "}";
                decreaseContextInDiffView = "{";
              };
              status = {
                checkForUpdate = "u";
                recentRepos = "<enter>";
              };
              files = {
                commitChanges = "c";
                commitChangesWithoutHook = "w";
                amendLastCommit = "A";
                commitChangesWithEditor = "C";
                confirmDiscard = "x";
                ignoreFile = "i";
                refreshFiles = "r";
                stashAllChanges = "s";
                viewStashOptions = "S";
                toggleStagedAll = "a";
                viewResetOptions = "D";
                fetch = "f";
                toggleTreeView = "`";
                openMergeOptions = "M";
                openStatusFilter = "<c-b>";
              };
              branches = {
                createPullRequest = "o";
                viewPullRequestOptions = "O";
                checkoutBranchByName = "c";
                forceCheckoutBranch = "F";
                rebaseBranch = "r";
                renameBranch = "R";
                mergeIntoCurrentBranch = "M";
                viewGitFlowOptions = "i";
                fastForward = "f";
                createTag = "T";
                pushTag = "P";
                setUpstream = "u";
                fetchRemote = "f";
              };
              commits = {
                squashDown = "s";
                renameCommit = "r";
                renameCommitWithEditor = "R";
                viewResetOptions = "g";
                markCommitAsFixup = "f";
                createFixupCommit = "F";
                squashAboveCommits = "S";
                moveDownCommit = "<c-j>";
                moveUpCommit = "<c-k>";
                amendToCommit = "A";
                pickCommit = "p";
                revertCommit = "t";
                cherryPickCopy = "c";
                cherryPickCopyRange = "C";
                pasteCommits = "v";
                tagCommit = "T";
                checkoutCommit = "<space>";
                resetCherryPick = "<c-R>";
                copyCommitMessageToClipboard = "<c-y>";
                openLogMenu = "<c-l>";
                viewBisectOptions = "b";
              };
              stash = {
                popStash = "g";
                renameStash = "r";
              };
              commitFiles = {
                checkoutCommitFile = "c";
              };
              main = {
                toggleDragSelect = "v";
                toggleDragSelect-alt = "V";
                toggleSelectHunk = "a";
                pickBothHunks = "b";
              };
              submodules = {
                init = "i";
                update = "u";
                bulkMenu = "b";
              };
            };
          };
        };
      };
      xdg.configFile = {
        "lazygit/themes".source = pkgs.local.tokyonight-lazygit;
      };
    };
}
