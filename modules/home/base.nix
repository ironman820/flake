{ config, inputs, ... }:
{
  flake.homeModules.base =
    { flakeRoot, pkgs, ... }:
    {
      imports = with config.flake.homeModules; [
        flatpak
        just
        kitty
        podman
        inputs.sops-nix.homeModules.sops
        sops
        yubikey
      ];
      home = {
        file."putty/sessions/FS Switch".source = flakeRoot + "/.config/putty/${"FS%20Switch"}";
        sessionPath = [
          "$HOME/bin"
          "$HOME/.local/bin"
        ];
        sessionVariables = {
          BROWSER = "google-chrome";
        };
        shellAliases = {
          "cat" = "bat";
          "diff" = "batdiff";
          "df" = "duf -only local";
          "du" = "dust -xd1 --skip-total";
          "ducks" =
            "\du -chs * 2>/dev/null | sort -rh | head -11 && du -chs .* 2>/dev/null | sort -rh | head -11";
          "gmount" = "rclone mount google:/ ~/Drive/";
          "htop" = "btop";
          "man" = "batman";
          "rg" = "batgrep";
          "top" = "btop";
          "watch" = "batwatch --command";
        };
        stateVersion = "25.05";
      };
      programs = {
        atuin = {
          enable = true;
          flags = [ "--disable-up-arrow" ];
        };
        bash = {
          bashrcExtra = ''
            eval $(${pkgs.bat-extras.batpipe}/bin/batpipe)
          '';
          enable = true;
          enableCompletion = true;
          enableVteIntegration = true;
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
            "--group-directories-first"
            "--header"
          ];
          git = true;
          icons = "auto";
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
      # xdg.configFile."btop/themes".source = pkgs.catppuccin-btop;
    };
}
