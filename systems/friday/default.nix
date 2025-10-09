{
  config,
  inputs,
  lib,
  pkgs,
  self',
  ...
}:
let
  inherit (lib) mkDefault;
  inherit (lib.mine) disabled enabled;
in
{
  imports = [
    ./hardware.nix
    ./disko.nix
  ];
  config = {
    boot = {
      kernel.sysctl = {
        "vm.overcommit_memory" = 1;
      };
      loader.grub = {
        efiSupport = true;
        device = "nodev";
        theme = "${pkgs.grub-cyberexs}/share/grub/themes/CyberEXS";
      };
      plymouth = enabled;
    };
    environment = {
      etc."tmux.reset.conf".text = ''
        # First remove *all* keybindings
        # unbind-key -a
        # Now reinsert all the regular tmux keys
        # bind ^X lock-server
        bind C-c new-window
        bind C-d detach
        # bind * list-clients

        bind H previous-window
        bind L next-window

        # bind r command-prompt "rename-window %%"
        bind R source-file /etc/tmux.conf
        # bind ^A last-window
        # bind ^W list-windows
        bind w list-windows
        bind z resize-pane -Z
        # bind ^L refresh-client
        bind C-r refresh-client
        # bind | split-window
        # bind s split-window -v -c "#{pane_current_path}"
        # bind v split-window -h -c "#{pane_current_path}"
        # bind '"' choose-window
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        # bind -r -T prefix , resize-pane -L 20
        # bind -r -T prefix . resize-pane -R 20
        # bind -r -T prefix - resize-pane -D 7
        # bind -r -T prefix = resize-pane -U 7
        bind : command-prompt
        bind * setw synchronize-panes
        # bind P set pane-border-status
        # bind c kill-pane
        # bind x swap-pane -D
        # bind S choose-session
        bind-key -T copy-mode-vi v send-keys -X begin-selection '';
      sessionVariables.NH_FLAKE = "/home/${config.mine.user.name}/git/flake";
      shellInit = ''
        gpg-connect-agent /bye
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      '';
      systemPackages =
        let
          myPythonPackages =
            py: with py; [
              autopep8
              black
              cffi
              click
              dbus-next
              debugpy
              flake8
              isort
              jedi
              jedi-language-server
              jsonrpc-base
              lsprotocol
              mypy
              pip
              pre-commit-hooks
              psutil
              pygobject3
              pynvim
              pytest
              pytest-expect
              pytest-lazy-fixture
              pytest-raises
              pytest-tornado
              PyVirtualDisplay
              rich
              rope
              typing-extensions
              typing-inspect
              xcffib
              yapf
            ];
        in
        with pkgs;
        [
          audacity
          blender
          calibre
          self'.packages.catppuccin-kitty
          self'.packages.catppuccin-lazygit
          (catppuccin-sddm.override {
            flavor = "mocha";
          })
          curlftpfs
          diff-so-fancy
          distrobox
          firmware-manager
          fuse
          gimp
          gnupg
          git
          git-filter-repo
          github-cli
          gh
          glab
          hplip
          imagemagick
          just
          kitty
          lazygit
          libreoffice-fresh
          mmex
          nh
          nix-output-monitor
          ntfs3g
          nvd
          obs-studio
          obsidian
          pavucontrol
          pipewire
          podman-compose
          pre-commit
          putty
          pyright
          (python3.withPackages myPythonPackages)
          remmina
          telegram-desktop
          tealdeer
          udiskie
          wireguard-tools
          vlc
          virt-viewer
          yubikey-personalization
          zed-editor
        ];
    };
    hardware = {
      bluetooth = enabled;
      gpgSmartcards = enabled;
    };
    home-manager.users."${config.mine.user.name}" = inputs.self.homeConfigurations.ironman;
    mine = {
      networking = {
        basic.networkmanager = enabled;
        profiles = enabled // {
          work = true;
        };
      };
      user.extraGroups = [
        "libvirtd"
      ];
    };
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      optimise.automatic = true;
      settings = {
        cores = 9;
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "root"
          "${config.mine.user.name}"
        ];
      };
    };
    nixCats = enabled;
    powerManagement = enabled // {
      powertop = enabled;
    };
    programs = {
      command-not-found = disabled;
      git = enabled // {
        lfs = enabled;
        prompt = enabled;
      };
      gnupg.agent = enabled // {
        enableSSHSupport = true;
      };
      java = enabled // {
        binfmt = true;
        package = pkgs.jdk17;
      };
      nix-index = enabled;
      nix-ld = enabled;
      ssh = {
        enableAskPassword = true;
        startAgent = false;
      };
      steam = enabled;
      system-config-printer = enabled;
      tmux = enabled // {
        baseIndex = 1;
        clock24 = true;
        customPaneNavigationAndResize = true;
        escapeTime = 0;
        extraConfigBeforePlugins = ''
          source-file /etc/tmux.reset.conf

          set -g detach-on-destroy off
          set -g renumber-windows on
          set -g set-clipboard on
          set -g status-position top

          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
          bind-key -T prefix g display-popup -E -w 95% -h 95% -d '#{pane_current_path}' lazygit
        '';
        historyLimit = 1000000;
        keyMode = "vi";
        shortcut = "Space";
        terminal = "screen-256color";
        plugins = with pkgs.tmuxPlugins; [
          catppuccin
          self'.packages.cheat-sh
          sensible
          inputs.tmux-sessionx.packages.${pkgs.system}.default
          yank
          fzf-tmux-url
        ];
      };
      virt-manager = enabled;
      winbox = enabled // {
        package = pkgs.winbox4;
      };
    };
    security = {
      pam.u2f = enabled // {
        settings = {
          cue = true;
          origin = "pam://ironman";
        };
      };
      rtkit = enabled;
    };
    services = {
      avahi = enabled;
      desktopManager.plasma6 = enabled;
      displayManager.sddm = enabled // {
        enableHidpi = true;
        theme = "catppuccin-mocha";
        wayland = enabled;
      };
      flatpak = enabled;
      fwupd = enabled;
      gvfs = enabled;
      logind = {
        killUserProcesses = true;
        lidSwitchExternalPower = "ignore";
      };
      openssh = enabled // {
        settings = {
          PasswordAuthentication = true;
          PermitRootLogin = mkDefault "no";
        };
      };
      pcscd = enabled;
      pipewire = enabled // {
        alsa = enabled // {
          support32Bit = true;
        };
        pulse = enabled;
      };
      power-profiles-daemon = disabled;
      printing = enabled // {
        cups-pdf = enabled;
        drivers = with pkgs; [
          gutenprint
          hplip
        ];
      };
      pulseaudio = disabled;
      resilio = enabled // {
        checkForUpdates = false;
        enableWebUI = true;
      };
      # system76-scheduler.settings.cfsProfiles = enabled;
      thermald = enabled;
      tlp = enabled // {
        settings = {
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          SATA_LINKPWR_ON_BAT = "med_power_with_dipm min_power";
          WIFI_PWR_ON_AC = "off";
          WIFI_PWR_ON_BAT = "off";
        };
      };
      udisks2 = enabled;
      udev.packages = with pkgs; [
        yubikey-personalization
      ];
      yubikey-agent = enabled;
    };
    sops = {
      age = {
        keyFile = "/etc/nixos/keys.txt";
        sshKeyPaths = [ ];
      };
      defaultSopsFile = ./secrets/sops.yaml;
      gnupg.sshKeyPaths = [ ];
    };
    system.stateVersion = "25.05";
    users.users = {
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3Ue/VoEgGG4nzoW3jpiwlnmWApkUyu/j1VmEwiSdy7"
      ];
      ironman.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3Ue/VoEgGG4nzoW3jpiwlnmWApkUyu/j1VmEwiSdy7"
      ];
    };
    virtualisation = {
      libvirtd = enabled;
      podman = enabled // {
        dockerCompat = true;
        dockerSocket = enabled;
      };
    };
    xdg.portal = enabled // {
      config.common.default = "*";
      xdgOpenUsePortal = true;
    };
  };
}
