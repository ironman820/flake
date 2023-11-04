{
  description = "My Nix Flakes";

  inputs = {
    flake = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:snowfallorg/flake";
    };
    nix-ld = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:mic92/nix-ld";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-22-05.url = "github:nixos/nixpkgs/nixos-22.05";
    # acc5f7b - IcedTea v8 Stable
    nixpkgs-acc5f7b.url = "github:nixos/nixpkgs/acc5f7b";
    # ba45a55 - The last stable update of PHP 7.4
    nixpkgs-ba45a55.url = "github:nixos/nixpkgs/ba45a55";
    snowfall-lib = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:snowfallorg/lib";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:mic92/sops-nix";
    };
    tokyo-night-sddm = {
      flake = false;
      url = "github:rototrash/tokyo-night-sddm";
    };
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    watershot = {
      inputs.nixpkgs.follows = "unstable";
      url = "github:kirottu/watershot";
    };
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;

      snowfall = {
        meta = {
          name = "ironman";
          title = "Ironman Config";
        };
        namespace = "ironman";
      };
    };
  in lib.mkFlake {
    channels-config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];
    };

    overlays = with inputs; [
      flake.overlays.default
    ];
    systems.modules = {
      nixos = with inputs; [
        nix-ld.nixosModules.nix-ld
        sops-nix.nixosModules.sops
      ];
    };

    systems.hosts = {
      e105-laptop.modules = with inputs; [
        nixos-hardware.nixosModules.common-gpu-intel
      ];
      ironman-laptop.modules = with inputs; [
        nixos-hardware.nixosModules.dell-inspiron-5509
        nixos-hardware.nixosModules.common-gpu-intel
      ];
    };

    alias = {
      shells.default = "ironman-shell";
    };
  };
}
