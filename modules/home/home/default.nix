{ options, pkgs, config, lib, inputs, ... }:
let
  inherit (lib) mkDefault;
  inherit (lib.ironman) enabled;
in
{
  config = {
    home = {
      file = {
        ".config/is_personal".text = mkDefault ''true'';
        ".config/is_server".text = mkDefault ''false'';
      };
      packages = (with pkgs; [
        chezmoi
        dig
        duf
        fzf
        htop
        inetutils
        jq
        neofetch
        (nerdfonts.override {
          fonts = [
            "FiraCode"
            "Inconsolata"
          ];
        })
        nodejs_18
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
        "ducks" = "du -chs * 2>/dev/null | sort -rh | head -11 && du -chs .* 2>/dev/null | sort -rh | head -11";
        "pdi" = "podman images";
        "pdo" = "podman images | awk '{print \$3,\$2}' | grep '<none>' | awk '{print \$1}' | xargs -t podman rmi";
        "pdr" = "podman rmi";
        "cat" = "bat";
      };
      stateVersion = "23.05";
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
