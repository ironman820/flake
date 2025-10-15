{
  flake.nixosModules.default-system =
    {
      config,
      inputs,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkDefault;
    in
    {
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
      environment = {
        sessionVariables.NH_FLAKE = "/home/${config.ironman.user.name}/git/flake";
        systemPackages =
          (with pkgs; [
            age
            appimage-run
            bat
            btop
            delta
            dig
            entr
            eza
            fzf
            git-extras
            lazygit
            nh
            nix-output-monitor
            nvd
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
      };
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
      nix = {
        channel.enable = false;
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
        optimise.automatic = true;
        settings = {
          cores = mkDefault 2;
          auto-optimise-store = true;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "root"
            "@wheel"
          ];
        };
      };
      nixpkgs = {
        config.allowUnfree = true;
        overlays = [
          inputs.self.overlays.default
        ];
      };
      programs = {
        command-not-found.enable = false;
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        git = {
          enable = true;
          lfs.enable = true;
        };
        mtr.enable = true;
        nix-index.enable = true;
        nix-ld.enable = true;
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
        ${config.ironman.user.name} = {
          createHome = true;
          description = config.ironman.user.fullName;
          extraGroups = [
            "dialout"
            "users"
            "wheel"
          ];
          home = "/home/${config.ironman.user.name}";
          initialPassword = "@ppl3Sauc3";
          isNormalUser = true;
          shell = pkgs.bash;
          uid = 1000;
        };
      };
      system.stateVersion = "25.05";
      xdg.portal = {
        enable = true;
        config.common.default = "*";
        xdgOpenUsePortal = true;
      };
    };
}
