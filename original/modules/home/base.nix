{
  flakeRoot,
  inputs,
  self,
  ...
}:
{
  flake.homeModules.base =
    {
      osConfig,
      pkgs,
      ...
    }:
    {
      imports =
        (with self.homeModules; [
          btop
          eza
          git
          ironman
          just
          nixvim
          tmux
        ])
        ++ (with inputs; [
          nix-flatpak.homeManagerModules.nix-flatpak
          nixvim.homeModules.nixvim
          noctalia.homeModules.default
          plasma-manager.homeModules.plasma-manager
        ]);
      home = {
        sessionVariables = {
          EDITOR = "nvim";
        };
        shellAliases = {
          d = "docker";
          df = "duf -only local";
          du = "dust -xd1 --skip-total";
          # "ducks" = "${pkgs.coreutils}/bin/du -chs * 2>/dev/null | sort -rh | head -11 && ${pkgs.coreutils}/bin/du -chs .* 2>/dev/null | sort -rh | head -11";
          gmount = "rclone mount google:/ ~/Drive/";
          htop = "btop";
          nv = "nvim";
          top = "btop";
        };
      };
      nixpkgs = {
        config.allowUnfree = true;
        overlays = [
          inputs.kineticwe.overlays.default
          inputs.self.overlays.default
        ];
      };
      programs = {
        atuin = {
          enable = true;
          flags = [ "--disable-up-arrow" ];
        };
        bash = {
          enable = true;
          enableCompletion = true;
          enableVteIntegration = true;
          historyControl = [ "ignoreboth" ];
          historySize = 32768;
        };
        dircolors.enable = true;
        fzf = {
          enable = true;
          enableBashIntegration = true;
          historyWidget.command = "";
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
