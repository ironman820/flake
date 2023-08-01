{ options, pkgs, config, lib, inputs, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.home;
in
{
  options.ironman.home = with types; {
    file = mkOpt attrs { } "Files that need added to the home manager's file settings.";
    extraOptions = mkOpt attrs { } "Extra attributes to add to the home config.";
  };

  config = {
    ironman.home.extraOptions = {
      home = {
        file = mkAliasDefinitions options.ironman.home.file;
        homeDirectory = "/home/${config.ironman.user.name}";
        packages = (with pkgs; [
          chezmoi
          devbox
          duf
          fzf
          git
          git-filter-repo
          github-cli
          glab
          htop
          jq
          just
          lazygit
          neofetch
          (nerdfonts.override {
            fonts = [
              "FiraCode"
              "Inconsolata"
            ];
          })
          nodejs_20
          poppler_utils
          pv
          restic
          ripgrep
          yq
          zip
        ]);
        sessionPath = [
          "$HOME/bin"
          "$HOME/.local/bin"
        ];
        shellAliases = {
          "ca" = "chezmoi add";
          "cc" = "chezmoi cd";
          "ce" = "chezmoi edit --apply";
          "cf" = "chezmoi forget";
          "ci" = "chezmoi init";
          "cr" = "chezmoi re-add";
          "cu" = "chezmoi update";
          "df" = "duf";
          "ducks" = "du -chs * 2>/dev/null | sort -rh | head -11";
          "js" = "just switch";
          "nano" = "nvim";
          "pdi" = "podman images";
          "pdo" = "podman images | awk '{print \$3,\$2}' | grep '<none>' | awk '{print \$1}' | xargs -t podman rmi";
          "pdr" = "podman rmi";
          "cat" = "bat";
        };
        stateVersion = config.system.stateVersion;
        username = config.ironman.user.name;
      };
      programs = {
        atuin = {
          enable = true;
          flags = [
            "--disable-up-arrow"
          ];
        };
        bash = {
          bashrcExtra = ''
            chezmoi update -a
          '';
          enable = true;
          enableCompletion = true;
          enableVteIntegration = true;
        };
        bat = {
          config.theme = "TwoDark";
          enable = true;
          extraPackages = with pkgs.bat-extras; [
            batdiff
            batman
            batgrep
            batwatch
          ];
        };
        dircolors = enabled;
        direnv = enabled;
        exa = {
          enable = true;
          enableAliases = true;
          extraOptions = [
            "--group-directories-first"
            "--header"
          ];
          git = true;
          icons = true;
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
          };
          ignores = [ ".direnv" "result" ];
          lfs = enabled;
          userName = config.ironman.user.fullName;
          userEmail = config.ironman.user.email;
        };
        gpg = {
          enable = true;
          settings = {
            personal-cipher-preferences = "AES256 AES192 AES";
            personal-digest-preferences = "SHA512 SHA384 SHA256";
            personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
            default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
            cert-digest-algo = "SHA512";
            s2k-digest-algo = "SHA512";
            s2k-cipher-algo = "AES256";
            charset = "utf-8";
            fixed-list-mode = true;
            no-comments = true;
            no-emit-version = true;
            no-greeting = true;
            keyid-format = "0xlong";
            list-options = "show-uid-validity";
            verify-options = "show-uid-validity";
            with-fingerprint = true;
            require-cross-certification = true;
            no-symkey-cache = true;
            use-agent = true;
            throw-keyids = true;
          };
        };
        home-manager = enabled;
        ssh = {
          compression = true;
          enable = true;
          forwardAgent = true;
          includes = [
            "~/.ssh/my-config"
          ];
        };
        starship = {
          enable = true;
          enableBashIntegration = true;
          settings = {
            username = {
              format = "user: [$user]($style) ";
              show_always = true;
            };
          };
        };
        zoxide = enabled;
      };
      services = {
        gpg-agent = {
          enable = true;
          enableSshSupport = true;
          extraConfig = ''
            ttyname $GPG_TTY
          '';
          defaultCacheTtl = 10800;
          maxCacheTtl = 21600;
        };
      };
    };

    home-manager = {
      # extraSpecialArgs = {
      #   inherit inputs;
      #   headless = false;
      # };
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${config.ironman.user.name} =
        mkAliasDefinitions options.ironman.home.extraOptions;
    };
  };
}
