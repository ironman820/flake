{ inputs, self, ... }:
{
  flake.nixosModules.base =
    {
      lib,
      pkgs,
      ...
    }:
    {
      imports = (with inputs; [
        disko.nixosModules.disko
        niri.nixosModules.niri
        nix-topology.nixosModules.default
        nixvim.nixosModules.nixvim
        noctalia.nixosModules.default
        noctalia-greeter.nixosModules.default
        sops-nix.nixosModules.sops
      ]) ++ (with self.nixosModules; [
        git
        ironman
        nix
        nixvim
        tmux
      ]);
      boot = {
        # kernel.sysctl = {
        #   "vm.swappiness" = 10;
        # };
        kernelParams = [
          "quiet"
        ];
        loader = {
          efi.canTouchEfiVariables = true;
          # timeout = 2;
        };
      };
      console = {
        font = ./files/EnvyCodeRNerdFontMono-Regular.psf;
        useXkbConfig = true; # use xkbOptions in tty.
      };
      environment.systemPackages = with pkgs; [
        age
        btop
        cifs-utils
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
        nixos-anywhere
        nodejs
        ntfs3g
        nvd
        p7zip
        pciutils
        pv
        qrencode
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
      networking.useDHCP = lib.mkDefault true;
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
