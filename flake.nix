{
  description = "My NixOS Flakes";

  # Sources needed for packages
  # Where possible, I have used flakehub's system as a source for repos
  inputs = {
    # Snowfallorg's Flake utility
    flake = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://flakehub.com/f/snowfallorg/flake/1.*.tar.gz";
    };
    # Home manager to keep track of dotfiles
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    # Package repo where all of my custom nix packages are stored
    ironman-apps = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ironman820/ironman-apps/snowfall";
    };
    # Nix-LD is a dynamic linker that tries to mimick FHS file systems for hard-coded applications
    nix-ld = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:mic92/nix-ld";
    };
    # Unstable repo for latest and greatest packages
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz";
    # Nixos curated Hardware settings/drivers
    nixos-hardware.url = "https://flakehub.com/f/NixOS/nixos-hardware/0.1.*.tar.gz";
    # Standard Nixpkgs
    nixpkgs-2311.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2311.*.tar.gz";
    # acc5f7b - IcedTea v8 Stable
    nixpkgs-acc5f7b.url = "github:nixos/nixpkgs/acc5f7b";
    # ba45a55 - The last stable update of PHP 7.4
    nixpkgs-ba45a55.url = "github:nixos/nixpkgs/ba45a55";
    snowfall-lib = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:snowfallorg/lib/dev";
    };
    # SOPS Based secret management to encrypt secrets updated to Github
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://flakehub.com/f/Mic92/sops-nix/0.1.*.tar.gz";
    };
  };

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

      # homes.modules = with inputs; [sops-nix.homeManagerModules.sops];

      overlays = (with inputs; [flake.overlays.default]) ++ ironmanapps;

      systems.modules = {
        nixos = with inputs; [
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
}
