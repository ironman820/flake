{
  flakeRoot,
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.microvms-base = { lib, pkgs, ... }: {
    imports =
      (with inputs; [
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = {
            inherit flakeRoot;
          };
        }
        nix-topology.nixosModules.default
        nixvim.nixosModules.nixvim
        sops-nix.nixosModules.sops
      ])
      ++ (with self.nixosModules; [
        git
        ironman
        microvms-nix
        nixvim
        tmux
      ]);
    boot = {
      kernelParams = [
        "quiet"
      ];
      loader = {
        efi.canTouchEfiVariables = true;
      };
    };
    console = {
      font = "${flakeRoot}/modules/files/EnvyCodeRNerdFontMono-Regular.psf";
      useXkbConfig = true; # use xkbOptions in tty.
    };
    environment.systemPackages = with pkgs; [
      age
      btop
      delta
      diff-so-fancy
      dig
      duf
      dust
      entr
      enum4linux
      eza
      inputs.snowfall-flake.packages.${pkgs.stdenv.hostPlatform.system}.flake
      fping
      fzf
      gcc
      glibc
      gnumake
      inetutils
      jq
      just
      fastfetch
      nix-output-monitor
      nodejs
      nvd
      p7zip
      pciutils
      pv
      rclone
      ripgrep
      ssh-to-age
      sops
      self.packages.${pkgs.stdenv.hostPlatform.system}.switchssh
      tealdeer
      unrar
      unzip
      wget
      yq
      zip
    ];
    fileSystems."/etc/ssh".neededForBoot = true;
    fonts.packages =
      (with pkgs; [
        meslo-lgs-nf
      ])
      ++ (with pkgs.nerd-fonts; [
        envy-code-r
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
      inputMethod.type = "ibus";
    };
    location.provider = "geoclue2";
    microvm = {
      shares = [
        {
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
          tag = "ro-store";
          proto = "virtiofs";
        }
        {
          source = "/etc/ssh";
          mountPoint = "/etc/ssh";
          tag = "ssh-keys";
          proto = "virtiofs";
        }
      ];
      writableStoreOverlay = "/nix/.rw-store";
    };
    programs = {
      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batgrep
          batman
          batpipe
          batwatch
          prettybat
        ];
      };
      # command-not-found.enable = false;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      git.prompt.enable = false;
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
        generateKey = true;
        keyFile = "/etc/nixos/keys.txt";
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      };
      gnupg.sshKeyPaths = [ ];
    };
    systemd.settings.Manager = {
      DefaultTimeoutStopSec = "10s";
    };
    time.timeZone = "America/Chicago";
    users.users.root = {
      initialHashedPassword = lib.mkForce null;
      initialPassword = "@ppl3Sauc3";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3Ue/VoEgGG4nzoW3jpiwlnmWApkUyu/j1VmEwiSdy7"
      ];
    };
    system.stateVersion = "25.05";
  };
}
