{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) fromTOML readFile;
  inherit (lib.ironman) enabled;
in {
  config = {
    home = {
      packages = with pkgs; [
        dig
        duf
        eltclsh
        fzf
        idracclient
        inetutils
        jq
        neofetch
        nerdfonts
        nodejs_18
        p7zip
        poppler_utils
        pv
        qrencode
        restic
        rclone
        ripgrep
        switchssh
        unzip
        yq
        zip
      ];
      sessionPath = ["$HOME/bin" "$HOME/.local/bin"];
      shellAliases = {
        "df" = "duf";
        "ducks" = "du -chs * 2>/dev/null | sort -rh | head -11 && du -chs .* 2>/dev/null | sort -rh | head -11";
        "gmount" = "rclone mount google:/ ~/Drive/";
      };
      stateVersion = "23.05";
    };
    manual = {
      html.enable = false;
      manpages.enable = false;
      json.enable = false;
    };
    programs = {
      atuin = {
        enable = true;
        flags = ["--disable-up-arrow"];
      };
      bash = {
        enable = true;
        enableCompletion = true;
        enableVteIntegration = true;
      };
      dircolors = enabled;
      direnv = enabled;
      eza = {
        enable = true;
        enableAliases = true;
        extraOptions = ["--group-directories-first" "--header"];
        git = true;
        icons = true;
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
      starship = {
        enable = true;
        enableBashIntegration = true;
        settings =
          {
            format = "$all";
            palette = "catppuccin_mocha";
          }
          // fromTOML
          (readFile "${inputs.catppuccin-starship}/palettes/mocha.toml");
      };
      zoxide = enabled;
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
  };
}
