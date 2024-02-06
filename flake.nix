{
  description = "My NixOS Flakes";

  # Sources needed for packages
  # Where possible, I have used flakehub's system as a source for repos
  inputs = {
    # catppuccin theme for grub
    catppuccin-grub = {
      flake = false;
      url = "github:catppuccin/grub";
    };
    # Snowfallorg's Flake utility
    flake = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://flakehub.com/f/snowfallorg/flake/1.1.0.tar.gz";
    };
    # Nix-LD is a dynamic linker that tries to mimick FHS file systems for hard-coded applications
    nix-ld = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:mic92/nix-ld";
    };
    # Nixos curated Hardware settings/drivers
    nixos-hardware.url = "https://flakehub.com/f/NixOS/nixos-hardware/0.1.*.tar.gz";
    # Standard Nixpkgs
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    # acc5f7b - IcedTea v8 Stable
    nixpkgs-acc5f7b.url = "github:nixos/nixpkgs/acc5f7b";
    # ba45a55 - The last stable update of PHP 7.4
    nixpkgs-ba45a55.url = "github:nixos/nixpkgs/ba45a55";
    # Catppuccin theme for SDDM
    sddm-catppuccin = {
      flake = false;
      url = "github:catppuccin/sddm";
    };
    # SOPS Based secret management to encrypt secrets updated to Github
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://flakehub.com/f/Mic92/sops-nix/0.1.*.tar.gz";
    };
    # Unstable repo for latest and greatest packages
    unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz";
  };

  # Our config that sets up systems
  outputs = {self, ...} @ inputs: let
    # Inherit functions and libraries needed for config variables
    inherit (builtins) listToAttrs map;
    inherit (inputs.nixpkgs) lib;

    # Define default import settings
    defaultImports = {
      inherit overlays;
      # Inherit the system type from our systemSettings variable
      inherit (systemSettings) system;

      # Allow unfree software
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        permittedInsecurePackages = ["openssl-1.1.1w"];
      };
    };

    # Host Systems to build below
    # If any of these need special arguments over what is given by default,
    # Don't add them here.
    hostSystems = [
      "e105-laptop"
      "friday"
      "git-home"
      "ironman-laptop"
      "liveiso"
      "pdns-home"
      "pdns-work"
      "pxe-home"
      "pxe-work"
      "qc-work"
      "rcm-work"
      "rcm2-home"
      "rcm2-work"
      "traefik-work"
    ];

    overlayList = [
      "adoptopenjdk-icedtea-web"
      "brave"
      "catppuccin-grub"
      "flake"
      "google-chrome"
      "hyprland"
      "networkmanagerapplet"
      "nvim"
      "oraclejdk8"
      "oraclejdk8-files"
      "pgadmin"
      "php7"
      "python3"
      "unixODBCDrivers"
    ];
    overlays =
      [
        (import ./lib {})
      ]
      ++ lib.lists.forEach overlayList (layer:
        import ./overlays/${layer} {
          inherit inputs self;
          inherit (systemSettings) system;
        });

    packageList = [
      "catppuccin-grub"
      "php"
      "sddm-catppuccin"
    ];

    # Import nixpkgs as pkgs for most applications
    pkgs = import inputs.nixpkgs defaultImports;

    # Custom system settings to be passed to other modules
    systemSettings = {
      # Default language encoding settings
      locale = "en_US.UTF-8";
      # Import modules for use with configs (extra packaging/application support)
      modules = with inputs; [
        # Updated Nix-LD support
        nix-ld.nixosModules.nix-ld
        # SOPS Implimentation for SOPS-Nix
        sops-nix.nixosModules.sops
        ./modules
      ];

      # Define the system as a 64-bit linux distro
      system = "x86_64-linux";
      # Set the default timezone
      timezone = "America/Chicago";
    };

    # User focussed settings
    userSettings = rec {
      # Default Window Manager
      wm = "hyprland";
      # Window manager type, auto-selected based on the WM used
      wmType =
        if (wm == "hyprland")
        then "wayland"
        else "x11";

      # Default applications
      browser = "floorp";
      term = "alacritty";
      editor = "nvim";

      # Script to open terminal if needed for default editor
      spawnEditor =
        if (editor == "emacsclient")
        then "emacsclient -c -a 'emacs'"
        else
          (
            if ((editor == "vim") || (editor == "nvim") || (editor == "nano"))
            then "exec " + term + " -e " + editor
            else editor
          );
      # Default fonts to use
      font = "FiraCode Nerd Font Retina";
      fontPkg = pkgs.nerdfonts;
    };
  in {
    # Inherit channels so we can use them in the Repl
    inherit lib pkgs;

    # OS configurations, importing config from the systems folder and
    # passing along additional variables as needed
    # this takes the list hostSystems from above and creates configs
    # by iterating over them.
    nixosConfigurations = listToAttrs (map (sys: {
        name = sys;
        value = lib.nixosSystem {
          inherit (systemSettings) system;
          modules = [./systems/${sys}] ++ systemSettings.modules;
          specialArgs = {
            inherit inputs pkgs self userSettings;
            inherit (pkgs) lib;
            hostName = sys;
          };
        };
      })
      hostSystems);
    packages.${systemSettings.system} = listToAttrs (map (pkg: {
        name = pkg;
        value = import ./packages/${pkg} {inherit inputs pkgs;};
      })
      packageList);
  };
}
