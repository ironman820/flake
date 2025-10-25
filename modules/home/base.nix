{ config, inputs, ... }:
{
  flake.homeModules.base =
    {
      flakeRoot,
      osConfig,
      pkgs,
      ...
    }:
    {
      imports =
        (with config.flake.homeModules; [
          bash
          flatpak
          git
          just
          kitty
          podman
          ssh
          sops
          tmux
          yubikey
        ])
        ++ (with inputs; [
          neovim.homeModules.default
          sops-nix.homeModules.sops
        ]);
      home = {
        file."putty/sessions/FS Switch".source = flakeRoot + "/.config/putty/${"FS%20Switch"}";
        homeDirectory = osConfig.users.users.${osConfig.ironman.user.name}.home;
        sessionPath = [
          "$HOME/bin"
          "$HOME/.local/bin"
        ];
        sessionVariables = {
          BROWSER = "google-chrome";
          EDITOR = "nvim";
        };
        shellAliases = {
          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";
          cat = "bat";
          d = "docker";
          decompress = "tar -xzf";
          diff = "batdiff";
          df = "duf -only local";
          du = "dust -xd1 --skip-total";
          # "ducks" =
          #   "${pkgs.coreutils}/bin/du -chs * 2>/dev/null | sort -rh | head -11 && ${pkgs.coreutils}/bin/du -chs .* 2>/dev/null | sort -rh | head -11";
          gmount = "rclone mount google:/ ~/Drive/";
          htop = "btop";
          man = "batman";
          nv = "nvim";
          rg = "batgrep";
          top = "btop";
          watch = "batwatch --command";
        };
        stateVersion = "25.05";
        username = osConfig.ironman.user.name;
      };
      nixCats.enable = true;
      nixpkgs = {
        config.allowUnfree = true;
        overlays = [
          inputs.self.overlays.default
        ];
      };
      programs = {
        atuin = {
          enable = true;
          flags = [ "--disable-up-arrow" ];
        };
        bat.enable = true;
        btop = {
          enable = true;
          settings = {
            color_theme = "catppuccin_mocha.theme";
            vim_keys = true;
          };
        };
        dircolors.enable = true;
        direnv = {
          enable = true;
          enableBashIntegration = true;
          nix-direnv.enable = true;
        };
        eza = {
          enable = true;
          enableBashIntegration = true;
          extraOptions = [
            "-lh"
            "--group-directories-first"
          ];
          git = true;
          icons = "auto";
          theme = {
            colourful = true;

            filekinds = {
              normal.foreground = "#c0caf5";
              directory.foreground = "#7aa2f7";
              symlink.foreground = "#2ac3de";
              pipe.foreground = "#414868";
              block_device.foreground = "#e0af68";
              char_device.foreground = "#e0af68";
              socket.foreground = "#414868";
              special.foreground = "#9d7cd8";
              executable.foreground = "#9ece6a";
              mount_point.foreground = "#b4f9f8";
            };

            perms = {
              user_read.foreground = "#2ac3de";
              user_write.foreground = "#bb9af7";
              user_execute_file.foreground = "#9ece6a";
              user_execute_other.foreground = "#9ece6a";
              group_read.foreground = "#2ac3de";
              group_write.foreground = "#ff9e64";
              group_execute.foreground = "#9ece6a";
              other_read.foreground = "#2ac3de";
              other_write.foreground = "#ff007c";
              other_execute.foreground = "#9ece6a";
              special_user_file.foreground = "#ff007c";
              special_other.foreground = "#db4b4b";
              attribute.foreground = "#737aa2";
            };

            size = {
              major.foreground = "#2ac3de";
              minor.foreground = "#9d7cd8";
              number_byte.foreground = "#a9b1d6";
              number_kilo.foreground = "#89ddff";
              number_mega.foreground = "#2ac3de";
              number_giga.foreground = "#ff9e64";
              number_huge.foreground = "#ff007c";
              unit_byte.foreground = "#a9b1d6";
              unit_kilo.foreground = "#89ddff";
              unit_mega.foreground = "#2ac3de";
              unit_giga.foreground = "#ff9e64";
              unit_huge.foreground = "#ff007c";
            };

            users = {
              user_you.foreground = "#3d59a1";
              user_root.foreground = "#bb9af7";
              user_other.foreground = "#2ac3de";
              group_yours.foreground = "#89ddff";
              group_root.foreground = "#bb9af7";
              group_other.foreground = "#c0caf5";
            };

            links = {
              normal.foreground = "#89ddff";
              multi_link_file.foreground = "#2ac3de";
            };

            git = {
              new.foreground = "#9ece6a";
              modified.foreground = "#bb9af7";
              deleted.foreground = "#db4b4b";
              renamed.foreground = "#2ac3de";
              typechange.foreground = "#2ac3de";
              ignored.foreground = "#545c7e";
              conflicted.foreground = "#ff9e64";
            };

            git_repo = {
              branch_main.foreground = "#737aa2";
              branch_other.foreground = "#b4f9f8";
              git_clean.foreground = "#292e42";
              git_dirty.foreground = "#bb9af7";
            };

            security_context = {
              colon.foreground = "#545c7e";
              user.foreground = "#737aa2";
              role.foreground = "#2ac3de";
              typ.foreground = "#3d59a1";
              range.foreground = "#9d7cd8";
            };

            file_type = {
              image.foreground = "#89ddff";
              video.foreground = "#b4f9f8";
              music.foreground = "#73daca";
              lossless.foreground = "#41a6b5";
              crypto.foreground = "#db4b4b";
              document.foreground = "#a9b1d6";
              compressed.foreground = "#ff9e64";
              temp.foreground = "#737aa2";
              compiled.foreground = "#737aa2";
              build.foreground = "#1abc9c";
              source.foreground = "#bb9af7";
            };

            punctuation.foreground = "#414868";
            date.foreground = "#e0af68";
            inode.foreground = "#737aa2";
            blocks.foreground = "#737aa2";
            header.foreground = "#a9b1d6";
            octal.foreground = "#ff9e64";
            flags.foreground = "#9d7cd8";

            symlink_path.foreground = "#89ddff";
            control_char.foreground = "#ff9e64";
            broken_symlink.foreground = "#ff007c";
            broken_path_overlay.foreground = "#ff007c";
          };
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
        lf = {
          enable = true;
          keybindings = {
            DD = "%trash $f";
          };
        };
        home-manager.enable = true;
        starship = {
          enable = true;
          enableBashIntegration = true;
        };
        zoxide.enable = true;
      };
      services = {
        gpg-agent = {
          enable = true;
          enableScDaemon = true;
          enableSshSupport = true;
          extraConfig = ''
            ttyname $GPG_TTY
          '';
          defaultCacheTtl = 10800;
          maxCacheTtl = 21600;
        };
        udiskie = {
          enable = true;
          tray = "never";
        };
      };
      xdg = {
        enable = true;
        configFile = {
          "tealdeer/config.toml".text = ''
            [updates]
            auto_update = true
          '';
          "btop/themes".source = pkgs.local.catppuccin-btop;
        };
      };
    };
}
