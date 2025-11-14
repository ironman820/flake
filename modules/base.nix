{ config, ... }:
{
  flake.nixosModules.base =
    {
      inputs',
      lib,
      pkgs,
      ...
    }:
    {
      imports = with config.flake.nixosModules; [
        apps-python
        ironman
        nix
      ];
      boot = {
        kernel.sysctl = {
          "vm.swappiness" = 10;
        };
        kernelParams = [
          "quiet"
        ];
        loader = {
          efi.canTouchEfiVariables = true;
          timeout = 2;
        };
      };
      console = {
        font = "Lat2-Terminus16";
        useXkbConfig = true; # use xkbOptions in tty.
      };
      environment.systemPackages =
        with pkgs;
        [
          age
          btop
          cifs-utils
          delta
          deploy-rs
          diff-so-fancy
          dig
          duf
          dust
          eltclsh
          entr
          enum4linux
          eza
          ffmpeg
          inputs'.snowfall-flake.packages.flake
          fzf
          gcc
          glab
          glibc
          gnumake
          hplip
          local.idracclient
          inetutils
          jq
          just
          neofetch
          nix-output-monitor
          nixos-anywhere
          nodejs
          ntfs3g
          nvd
          p7zip
          poppler-utils
          pv
          qrencode
          rclone
          ripgrep
          ssh-to-age
          sops
          local.switchssh
          tealdeer
          trashy
          unzip
          wget
          wireguard-tools
          yq
          zip
        ];
      fonts.packages =
        (with pkgs;
        [
          meslo-lgs-nf
        ])
        ++ (with pkgs.nerd-fonts; [
          fira-code
          fira-mono
          inconsolata
        ]);
      hardware.enableRedistributableFirmware = true;
      home-manager = {
        backupFileExtension = "backup";
        useGlobalPkgs = false;
        useUserPackages = true;
      };
      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
          LC_ADDRESS = "en_US.UTF-8";
          LC_IDENTIFICATION = "en_US.UTF-8";
          LC_MEASUREMENT = "en_US.UTF-8";
          LC_MONETARY = "en_US.UTF-8";
          LC_NAME = "en_US.UTF-8";
          LC_NUMERIC = "en_US.UTF-8";
          LC_PAPER = "en_US.UTF-8";
          LC_TELEPHONE = "en_US.UTF-8";
          LC_TIME = "en_US.UTF-8";
        };
      };
      location.provider = "geoclue2";
      networking.useDHCP = lib.mkDefault true;
      nixCats.enable = true;
      programs = {
        appimage = {
          enable = true;
          binfmt = true;
        };
        bat = {
          enable = true;
          extraPackages = with pkgs.bat-extras; [
            batdiff
            # package broken in 2025-11-01
            # batgrep
            batman
            batpipe
            batwatch
            prettybat
          ];
        };
        command-not-found.enable = false;
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        java = {
          binfmt = true;
          enable = true;
          package = pkgs.jdk;
        };
        mtr.enable = true;
      };
      security.sudo = {
        execWheelOnly = true;
      };
      services.openssh.enable = true;
      sops = {
        age = {
          generateKey = false;
          keyFile = "/etc/nixos/keys.txt";
          sshKeyPaths = [ ];
        };
        gnupg.sshKeyPaths = [ ];
      };
      systemd.settings.Manager = {
        DefaultTimeoutStopSec = "10s";
      };
      time.timeZone = "America/Chicago";
      users.users.root = {
        initialPassword = "@ppl3Sauc3";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3Ue/VoEgGG4nzoW3jpiwlnmWApkUyu/j1VmEwiSdy7"
        ];
      };
      system.stateVersion = "25.05";
    };
}
