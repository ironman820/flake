{
  flake.nixosModules.default-system = {config, inputs, lib, pkgs, ...}: {
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
        (with pkgs; [
          age
          appimage-run
          bat
          btop
          delta
          entr
          eza
          fzf
          git-extras
          lazygit
          p7zip
          ssh-to-age
          inputs.snowfall-flake.packages.${pkgs.system}.flake
          sops
          wget
        ])
        ++ (with pkgs.bat-extras; [
          batdiff
          batgrep
          batman
          batpipe
          batwatch
          prettybat
        ]);
      fonts.packages =
        with pkgs;
        [
          meslo-lgs-nf
        ]
        ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
      hardware.enableRedistributableFirmware = true;
      home-manager = {
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
      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "root"
          "@wheel"
        ];
      };
      nixpkgs.config.allowUnfree = true;
      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        git = {
          enable = true;
          lfs.enable = true;
        };
        mtr.enable = true;
      };
      security.sudo = {
        execWheelOnly = true;
      };
      systemd.settings.Manager = {
        DefaultTimeoutStopSec = "10s";
      };
      time.timeZone = "America/Chicago";
      users.users = {
        root.initialPassword = "@ppl3Sauc3";
        ${config.ironman.user} = {
          extraGroups = [
            "dialout"
          ];
          initialPassword = "@ppl3Sauc3";
        };
      };
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      system.stateVersion = "25.05";
  };
}
