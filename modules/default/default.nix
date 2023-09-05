{ config, inputs, lib, options, pkgs, ... }:
with lib;
{
  config = {
    boot = {
      kernelParams = [
        "i915.modeset=1"
        "i915.fastboot=1"
        "i915.enable_guc=2"
        "i915.enable_psr=1"
        "i915.enable_fbc=1"
        "i915.enable_dc=2"
        "quiet"
      ];
      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          efiSupport = true;
          device = "nodev";
        };
        timeout = 2;
      };
      plymouth = {
        enable = true;
      };
    };
    console = {
      font = "Lat2-Terminus16";
      packages = with pkgs; [
        inconsolata-nerdfont
      ];
      useXkbConfig = true; # use xkbOptions in tty.
    };
    environment = {
      gnome.excludePackages = (with pkgs; [
        gnome-tour
        gnome-photos
      ]) ++ (with pkgs.gnome; [
        cheese
        gnome-maps
        gnome-software
      ]);
      shellInit = ''
        gpg-connect-agent /bye
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      '';
      systemPackages = (with pkgs; [
        age
        devbox
        distrobox
        fzf
        gcc
        git-extras
        glibc
        gnome.seahorse
        gnupg
        libva-utils
        (nerdfonts.override {
          fonts = [
            "FiraCode"
            "Inconsolata"
          ];
        })
        networkmanagerapplet
        nix-index
        ntfs3g
        p7zip
        podman-compose
        rnix-lsp
        ssh-to-age
        sops
        terminus-nerdfont
        yubikey-personalization
        wget
      ]);
    };
    hardware = {
      bluetooth.enable = true;
      gpgSmartcards.enable = true;
      opengl.enable = true;
      pulseaudio.enable = false;
    };
    home-manager.users.${config.ironman.user.name} = {
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          enable-hot-corners = false;
          font-antialiasing = "rgba";
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
        "org/gnome/desktop/screensaver" = {
          lock-delay = "unit32 30";
          lock-enabled = true;
        };
        "org/gnome/desktop/session" = {
          idle-delay = "unit32 300";
        };
        "org/gnome/desktop/wm/keybindings" = {
          close = [ "<Super>q" ];
        };
        "org/gnome/desktop/wm/preferences" = {
          titlebar-font = "FiraCode Nerd Font Bold 11";
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          home = [ "<Super>f" ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Super>t";
          name = "Console";
          command = "kgx";
        };
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [
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
        "org/gnome/shell/extensions/lockkeys" = {
          style = "show-hide";
        };
        "org/gnome/shell/extensions/pano" = {
          paste-on-select = false;
          play-audio-on-copy = false;
          send-notification-on-copy = false;
        };
        "org/gnome/shell/extensions/tactile" = {
          show-tiles = [ "<Super>w" ];
        };
        "org/gnome/system/location" = {
          enabled = false;
        };
      };
      home = {
        file = {
          ".config/is_server".text = ''false'';
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
              sudo nixos-rebuild switch --flake ~/.config/flake#

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
        homeDirectory = "/home/${config.ironman.user.name}";
        packages = (with pkgs; [
          blender
          brave
          chezmoi
          devbox
          duf
          element-desktop-wayland
          ffmpeg
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
          handbrake
          htop
          jq
          just
          lazygit
          libreoffice-fresh
          microsoft-edge
          neofetch
          (nerdfonts.override {
            fonts = [
              "FiraCode"
              "Inconsolata"
            ];
          })
          nodejs_20
          obs-studio
          obsidian
          poppler_utils
          putty
          pv
          remmina
          restic
          ripgrep
          telegram-desktop
          vlc
          virt-manager
          virt-viewer
          vscode
          yq
          yubioath-flutter
          zip
          zoom-us
          zotero
        ]) ++ (with pkgs.gnomeExtensions; [
          appindicator
          caffeine
          compact-top-bar
          lock-keys
          no-overview
          pano
          power-profile-switcher
          syncthing-indicator
          tactile
          weather-oclock
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
          "ducks" = "du -chs * 2>/dev/null | sort -rh | head -11";
          "js" = "just switch";
          "nano" = "nvim";
          "pdi" = "podman images";
          "pdo" = "podman images | awk '{print \$3,\$2}' | grep '<none>' | awk '{print \$1}' | xargs -t podman rmi";
          "pdr" = "podman rmi";
          "cat" = "bat";
        };
        stateVersion = config.system.stateVersion;
        username = config.ironman.user.name;
      };
      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.tela-icon-theme;
          name = "Tela-black-dark";
        };
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
        dircolors.enable = true;
        direnv.enable = true;
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
          diff-so-fancy.enable = true;
          enable = true;
          extraConfig = {
            feature.manyFiles = true;
            init.defaultBranch = "main";
            gpg.format = "ssh";
          };
          ignores = [ ".direnv" "result" ];
          lfs.enable = true;
          userName = "Nicholas Eastman";
          userEmail = "29488820+ironman820@users.noreply.github.com";
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
        home-manager.enable = true;
        neovim = {
          defaultEditor = true;
          enable = true;
          plugins = with pkgs.vimPlugins; [
            nvchad
            vim-tmux-navigator
          ];
          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;
        };
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
        zoxide.enable = true;
      };
      services = {
        gnome-keyring = {
          enable = true;
        };
        gpg-agent = {
          enable = true;
          enableScDaemon = true;
          enableSshSupport = true;
          extraConfig = ''
            ttyname $GPG_TTY
          '';
          defaultCacheTtl = 10800;
          maxCacheTtl = 21600;
          pinentryFlavor = "gnome3";
        };
        syncthing.enable = true;
      };
      sops = {
        age.keyFile = "/home/${config.ironman.user.name}/.config/sops/age/keys.txt";
        defaultSopsFile = ../../../secrets/sops.yaml;
      };
      xdg = {
        configFile."nvim" = {
          recursive = true;
          source = "${pkgs.vimPlugins.nvchad}";
        };
        enable = true;
      };
    };
    i18n.defaultLocale = "en_US.UTF-8";
    ironman.sops.secrets = {
      da_psk = {
        format = "binary";
        mode = "0400";
        path = "/etc/NetworkManager/system-connections/DumbledoresArmy.nmconnection";
        sopsFile = ../../secrets/da.wifi;
      };
      user_pass = {
        mode = "0400";
        neededForUsers = true;
        sopsFile = ../../secrets/sops.yaml;
      };
    };
    location.provider = "geoclue2";
    networking = {
      enableIPv6 = false;
      firewall = {
        allowedTCPPorts = [
          8291
          8384
          22000
          24800
        ];
        allowedUDPPorts = [
          1900
          5678
          20561
          21027
          22000
        ];
      };
      networkmanager = {
        enable = true;
        plugins = with pkgs.gnome; [
          networkmanager-openvpn
        ];
      };
      nftables.enable = true;
    };
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      optimise.automatic = true;
      settings = {
        auto-optimise-store = true;
        cores = 2;
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users = [
          "root"
          config.ironman.user.name
        ];
      };
    };
    programs = {
      dconf.enable = true;
      git = {
        enable = true;
        lfs.enable = true;
      };
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryFlavor = "gnome3";
      };
      java = {
        binfmt = true;
        enable = true;
        package = pkgs.jdk17;
      };
      mtr.enable = true;
      nix-ld.enable = true;
      ssh = {
        enableAskPassword = true;
        startAgent = false;
      };
      xwayland.enable = true;
    };
    security = {
      pam.u2f = {
        enable = true;
        cue = true;
        origin = "pam://ironman";
      };
      rtkit.enable = true;
      sudo = {
        execWheelOnly = true;
      };
    };
    services = {
      flatpak.enable = true;
      gnome.gnome-keyring.enable = true;
      logind = {
        killUserProcesses = true;
        lidSwitchExternalPower = "ignore";
      };
      openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
        };
      };
      pcscd.enable = true;
      pipewire = {
        alsa.enable = true;
        enable = true;
        pulse.enable = true;
      };
      printing.enable = true;
      udev.packages = with pkgs; [
        gnome.gnome-settings-daemon
        yubikey-personalization
      ];
      xserver = {
        desktopManager.gnome.enable = true;
        displayManager = {
          defaultSession = "gnome";
          gdm.enable = true;
        };
        enable = true;
        layout = "us";
        libinput = {
          enable = true;
          touchpad.naturalScrolling = true;
        };
      };
      yubikey-agent.enable = true;
    };
    sound.enable = true;
    system.stateVersion = "23.05";
    systemd.extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
    time.timeZone = "America/Chicago";
    users.users.${config.ironman.user.name} = {
      extraGroups = [
        "dialout"
        "libvirtd"
        "networkmanager"
        "wheel"
      ];
      isNormalUser = true;
      home = "/home/${config.ironman.user.name}";
      group = "users";
      passwordFile = config.sops.secrets.user_pass.path;
      shell = pkgs.bash;
      uid = 1000;
    };
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.package = pkgs.qemu_kvm;
      };
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
      };
    };
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}
