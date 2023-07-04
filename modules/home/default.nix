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
    ironman.home = {
      file = mkMerge [
        ({
          ".justfile".source = ./files/justfile;
        })
        (mkIf (config.ironman.user.name == "ironman") {
          ".config/sops/age/keys.txt.age".source = ./keys/keys.txt.age;
          ".ssh/id_ed25519_sk.pub".source = ./keys/id_ed25519_sk.pub;
          ".ssh/github_home.pub".source = ./keys/github_home.pub;
          ".ssh/id_rsa_yubikey.pub".source = ./keys/id_rsa_yubikey.pub;
        })
      ];
      extraOptions = {
        dconf.settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            enable-hot-corners = false;
          };
          "org/gnome/desktop/notifications" = {
            show-in-lock-screen = false;
          };
          "org/gnome/desktop/privacy" = {
            old-files-age = "unit32 30";
            recent-files-max-age = "30";
            remember-recent-files = true;
            remove-old-trash-files = true;
          };
          "org/gnome/desktop/session" = {
            idle-delay = "unit32 300";
          };
          "org/gnome/desktop/screensaver" = {
            lock-delay = "unit32 30";
            lock-enabled = true;
          };
          "org/gnome/shell/extensions/lockkeys" = {
            style = "show-hide";
          };
          "org/gnome/shell/extensions/pano" = {
            paste-on-select = false;
            play-audio-on-copy = false;
            send-notification-on-copy = false;
          };
          "org/gnome/shell/extensions/tactile" = {
            show-tiles = ["<Super>w"];
          };
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = [
              "WallpaperSwitcher@Rishu"
              "appindicatorsupport@rgcjonas.gmail.com"
              "caffeine@patapon.info"
              "gnome-compact-top-bar@metehan-arslan.github.io"
              "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
              "lockkeys@vaina.lt"
              "no-overview@fthx"
              "pano@elhan.io"
              "power-profile-switcher@eliapasquali.github.io"
              "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
              "syncthing@gnome.2nv2u.com"
              "tactile@lundal.io"
              "user-theme@gnome-shell-extensions.gcampax.github.com"
              "weatheroclock@CleoMenezesJr.github.io"
            ];
          };
          "org/gnome/system/location" = {
            enabled = false;
          };
        };
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
          packages = (with pkgs; [
            blender
            brave
            calibre
            chezmoi
            devbox
            duf
            element-desktop-wayland
            firefox
            fzf
            gimp
            git
            git-filter-repo
            github-cli
            glab
            gnome.gnome-tweaks
            gnome-extension-manager
            google-chrome
            htop
            jq
            just
            lazygit
            libreoffice-fresh
            microsoft-edge
            neofetch
            (nerdfonts.override { fonts = [ "FiraCode" ]; })
            nodejs_20
            obs-studio
            obsidian
            poppler_utils
            putty
            pv
            restic
            ripgrep
            telegram-desktop
            virt-manager
            virt-viewer
            vlc
            vscode
            yq
            yubioath-flutter
            zip
            zotero
          ]) ++ (with pkgs.gnomeExtensions; [
            syncthing-indicator
            appindicator
            caffeine
            compact-top-bar
            lock-keys
            no-overview
            pano
            power-profile-switcher
            tactile
            wallpaper-switcher
            weather-oclock
          ]);
          sessionPath = [
            "$HOME/bin"
            "$HOME/.local/bin"
          ];
          sessionVariables = {
            EDITOR = "vim";
          };
          shellAliases = {
            "agenix" = "nix run github:ryantm/agenix --";
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
            signing = {
              key = "~/.ssh/github_home";
              signByDefault = builtins.stringLength "~/.ssh/github_home" > 0;
            };
            userName = config.ironman.user.fullName;
            userEmail = config.ironman.user.email;
          };
          gpg = {
            enable = true;
            scdaemonSettings = {
              reader-port = "Yubico";
              disable-ccid = true;
              pcsc-shared = true;
            };
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
          vim = {
            defaultEditor = true;
            enable = true;
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
            pinentryFlavor = "gnome3";
          };
          syncthing = enabled;
        };
        xdg = enabled;
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
