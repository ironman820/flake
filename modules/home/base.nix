{ config, inputs, ... }:
{
  flake.homeModules.base =
    {
      flakeRoot,
      osConfig,
      ...
    }:
    {
      imports =
        (with config.flake.homeModules; [
          bash
          btop
          eza
          flatpak
          git
          just
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
        dircolors.enable = true;
        direnv = {
          enable = true;
          enableBashIntegration = true;
          nix-direnv.enable = true;
        };
        fzf = {
          enable = true;
          enableBashIntegration = true;
          tmux.enableShellIntegration = true;
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
        };
      };
    };
}
