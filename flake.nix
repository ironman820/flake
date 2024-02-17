{
  description = "My NixOS Flakes";

  # Our config that sets up systems
  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;

      channels-config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        permittedInsecurePackages = ["openssl-1.1.1w"];
      };

      snowfall = {
        meta = {
          name = "ironman";
          title = "Ironman Config";
        };
        namespace = "mine";
      };
    };
    ironmanapps = inputs.nixpkgs.lib.attrsets.foldlAttrs (input: _: value: input ++ [value]) [] inputs.ironman-apps.overlays;
  in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        permittedInsecurePackages = ["openssl-1.1.1w"];
      };

      overlays = (with inputs; [flake.overlays.default]) ++ ironmanapps;

      systems.modules = {
        nixos = with inputs; [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
          nix-ld.nixosModules.nix-ld
          sops-nix.nixosModules.sops
        ];
      };

      systems.hosts = {
        e105-laptop.modules = with inputs; [nixos-hardware.nixosModules.common-gpu-intel];
        ironman-laptop.modules = with inputs; [
          nixos-hardware.nixosModules.dell-inspiron-5509
          nixos-hardware.nixosModules.common-gpu-intel
        ];
      };

      alias = {shells.default = "ironman-shell";};
    };

  # Sources needed for packages
  # Where possible, I have used flakehub's system as a source for repos
  inputs = {
    # Snowfallorg's Flake utility
    flake = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:snowfallorg/flake";
    };
    # Home manager to keep track of dotfiles
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-23.11";
    };
    # Package repo where all of my custom nix packages are stored
    ironman-apps = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ironman820/ironman-apps";
    };
    # Nix-LD is a dynamic linker that tries to mimick FHS file systems for hard-coded applications
    nix-ld = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:mic92/nix-ld";
    };
    # Standard Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # Nixos curated Hardware settings/drivers
    nixos-hardware.url = "github:nixos/nixos-hardware";
    # acc5f7b - IcedTea v8 Stable
    nixpkgs-acc5f7b.url = "github:nixos/nixpkgs/acc5f7b";
    # ba45a55 - The last stable update of PHP 7.4
    nixpkgs-ba45a55.url = "github:nixos/nixpkgs/ba45a55";
    snowfall-lib = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:snowfallorg/lib";
    };
    # SOPS Based secret management to encrypt secrets updated to Github
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
    # Unstable repo for latest and greatest packages
    unstable.url = "github:NixOS/nixpkgs";
    waybar.url = "github:alexays/waybar";
  };
}
