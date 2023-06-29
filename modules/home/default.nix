{ options, pkgs, config, lib, inputs, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.home;
in {
  options.ironman.home = with types; {
    file = mkOpt attrs {} "Files that need added to the home manager's file settings.";
    extraOptions = mkOpt attrs { } "Extra attributes to add to the home config.";
  };

  config = {
    ironman.home.file = {
      ".ssh/id_ed25519_sk.pub".source = ./keys/id_ed25519_sk.pub;
      ".ssh/id_ed25519_sk_work.pub".source = ./keys/id_ed25519_sk_work.pub;
      ".ssh/github_home.pub".source = ./keys/github_home.pub;
      ".ssh/id_rsa_yubikey.pub".source = ./keys/id_rsa_yubikey.pub;
    };
    ironman.home.extraOptions = {
      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.tela-icon-theme;
          name = "Tela-black-dark";
        };
        theme = {
          package = pkgs.orchis-theme;
          name = "Orchis-Dark-Compact";
        };
      };
      home = {
        file = mkAliasDefinitions options.ironman.home.file;
        homeDirectory = "/home/${config.ironman.user.name}";
        packages = with pkgs; [
          age
          birdtray
          chezmoi
          devbox
          duf
          fzf
          git
          git-filter-repo
          github-cli
          glab
          google-chrome
          htop
          jq
          just
          lazygit
          neofetch
          (nerdfonts.override { fonts = [ "FiraCode" ]; })
          networkmanagerapplet
          nodejs_20
          poppler_utils
          putty
          pv
          restic
          ripgrep
          teamviewer
          teams
          virt-manager
          virt-viewer
          vscode
          yq
          zip
        ];
        sessionPath = [
          "$HOME/bin"
          "$HOME/.local/bin"
        ];
        sessionVariables = {
          EDITOR = "vim";
        };
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
          "nano" = "vim";
          "pdi" = "podman images";
          "pdo" = "podman images | awk '{print \$3,\$2}' | grep '<none>' | awk '{print \$1}' | xargs -t podman rmi";
          "pdr" = "podman rmi";
          "cat" = "bat";
        };
        stateVersion = "23.05";
        username = config.ironman.user.name;
      };
      programs = {
        atuin.enable = true;
        bat = {
          config.theme = "TwoDark";
          enable = true;
        };
        direnv.enable = true;
        dircolors.enable = true;
        exa = {
          enable = true;
          enableAliases = true;
          extraOptions = [
            "--group-directories-first"
            "--header"
          ];
        };
        git = {
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
        home-manager = enabled;
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
        bash = {
          bashrcExtra = ''
            flash-to(){
              if [ $(${pkgs.file}/bin/file $1 --mime-type -b) == "application/zstd" ]; then
                echo "Flashing zst using zstdcat | dd"
                ( set -x; ${pkgs.zstd}/bin/zstdcat $1 | sudo dd of=$2 status=progress iflag=fullblock oflag=direct conv=fsync,noerror bs=64k )
              elif [ $(${pkgs.file}/bin/file $2 --mime-type -b) == "application/xz" ]; then
                echo "Flashing xz using xzcat | dd"
                ( set -x; ${pkgs.xz}/bin/xzcat $1 | sudo dd of=$2 status=progress iflag=fullblock oflag=direct conv=fsync,noerror bs=64k )
              else
                echo "Flashing arbitrary file $1 to $2"
                sudo dd if=$1 of=$2 status=progress conv=sync,noerror bs=64k
              fi
            }

            export EDITOR=vim

            encryptFile() {
              cat $1 | ${lib.getExe pkgs.openssl} enc -aes256 -pbkdf2 -base64
            }
            decryptFile() {
              cat $1 | ${lib.getExe pkgs.openssl} aes-256-cbc -d -pbkdf2 -a
            }
          '';
          enable = true;
          enableCompletion = true;
          enableVteIntegration = true;
          initExtra = ''
            EDITOR=vim
          '';
        };
        vim = {
          defaultEditor = true;
          enable = true;
        };
        zoxide.enable = true;
      };
      xdg = enabled;
    };

    home-manager = {
      extraSpecialArgs = {
        inherit inputs;
        headless = false;
      };
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${config.ironman.user.name} =
        mkAliasDefinitions options.ironman.home.extraOptions;
    };
  };
}