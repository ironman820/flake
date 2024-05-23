{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) enabled;

  imp = config.mine.home.impermanence.enable;
in {
  config = {
    home = {
      packages = with pkgs; [
        dig
        duf
        du-dust
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
      persistence."/persist/home".directories = mkIf imp [
        ".local/share/atuin"
      ];
      sessionPath = ["$HOME/bin" "$HOME/.local/bin"];
      shellAliases = {
        "df" = "duf -only local";
        "du" = "dust -xd1 --skip-total";
        # "ducks" = "du -chs * 2>/dev/null | sort -rh | head -11 && du -chs .* 2>/dev/null | sort -rh | head -11";
        "gmount" = "rclone mount google:/ ~/Drive/";
      };
      stateVersion = "23.05";
    };
    # manual = {
    #   html.enable = false;
    #   manpages.enable = false;
    #   json.enable = false;
    # };
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
      direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv = enabled;
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
