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
        ".justfile".text = ''
          default:
            @just --list

          apps:
            flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            flatpak install -uy com.usebottles.bottles
            flatpak install -uy com.github.tchx84.Flatseal

          bios:
            systemctl reboot --firmware-setup

          changelogs:
            rpm-ostree db diff --changelogs

          distrobox-debian:
            echo 'Creating Debian distrobox ...'
            distrobox create --image quay.io/toolbx-images/debian-toolbox:unstable -n debian -Y

          distrobox-fedora:
            ./scripts/just/stop-fedora
            distrobox create -i fedora -n fedora -Y

          distrobox-opensuse:
            echo 'Creating openSUSE distrobox ...'
            distrobox create --image quay.io/toolbx-images/opensuse-toolbox:tumbleweed -n opensuse -Y

          distrobox-u16:
            ./scripts/just/stop-u16
            echo 'Creating Ubuntu 16.04 distrobox...'
            distrobox create --image ghcr.io/ironman820/ubuntu-toolbox:16.04 -n u16 --init-hooks 'echo "$(uname -n)" > /etc/hostname; unset SESSION_MANAGER' -Y

          distrobox-u18:
            ./scripts/just/stop-u18
            echo 'Creating Ubuntu 18.04 distrobox...'
            distrobox create --image ghcr.io/ironman820/ubuntu-toolbox:18.04 -n u18 --init-hooks 'echo "$(uname -n)" > /etc/hostname; unset SESSION_MANAGER' -Y

          distrobox-ubuntu:
            ./scripts/just/stop-ubuntu
            echo 'Creating Ubuntu distrobox ...'
            distrobox create --image ghcr.io/ironman820/ubuntu-toolbox:latest -n ubuntu -I --init-hooks 'echo "$(uname -n)" > /etc/hostname' -Y

          distrobox-universal:
            echo 'Creating Universal Development distrobox ...'
            distrobox create --image mcr.microsoft.com/devcontainers/universal:latest -n universal -Y

          switch:
            flake switch ~/.config/flake#

          touch:
            pip install --upgrade gnome-extensions-cli
            gext install improvedosk@nick-shmyrev.dev
            gext install gestureImprovements@gestures

          update:
            #!/usr/bin/env bash
            cd ~/.config/flake
            flake update
            flake switch
            flatpak update -y
            distrobox upgrade -a

          upgrade:
            #!/usr/bin/env bash
            just distrobox-ubuntu
            just distrobox-u16
            just distrobox-u18
            cd ~/.config/flake
            flake update
            flake switch
            flatpak update -y
            distrobox upgrade -a
        '';
      };
      packages = (with pkgs; [
        chezmoi
        dig
        duf
        fzf
        git
        git-filter-repo
        github-cli
        glab
        htop
        inetutils
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
        "js" = "just switch";
        "nano" = "nvim";
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
          key = "~/.ssh/github";
          signByDefault = true;
        };
        userName = config.ironman.home.user.fullName;
        userEmail = config.ironman.home.user.email;
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
