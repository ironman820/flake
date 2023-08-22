{
  description = "My Nix Flakes";

  inputs = {
    flake = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:snowfallorg/flake";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-23.05";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # acc5f7b - IcedTea v8 Stable
    nixpkgs-acc5f7b.url = "github:nixos/nixpkgs/acc5f7b";
    # ba45a55 - The last stable update of PHP 7.4
    nixpkgs-ba45a55.url = "github:nixos/nixpkgs/ba45a55";
    # 11ff7 - Oracle JDK 8
    # nixpkgs-11ff7.url = "nixpkgs/b70a4436c617de1576c56b85c8338b5b51c18994";
    # ba6292f - msodbcsql17 v 17.5.1.1
    # nixpkgs-ba6292f.url = "github:nixos/nixpkgs/ba6292f";
    snowfall-lib = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:snowfallorg/lib";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:mic92/sops-nix";
    };
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "openssl-1.1.1v"
        ];
      };

      overlays = with inputs; [
        flake.overlays.default
      ];

      systems.modules = with inputs; [
        home-manager.nixosModules.home-manager
        sops-nix.nixosModules.sops
      ];

      systems.hosts = {
        e105-laptop.modules = with inputs; [
          # nixos-hardware.nixosModules.system76
          nixos-hardware.nixosModules.common-gpu-intel
        ];
        ironman-laptop.modules = with inputs; [
          nixos-hardware.nixosModules.dell-inspiron-5509
          nixos-hardware.nixosModules.common-gpu-intel
        ];
      };
    };
}
