{
  description = "My Nix Flakes";

  inputs = {
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-23.05";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # acc5f7b - IcedTea v8 Stable
    nixpkgs-acc5f7b.url = "github:nixos/nixpkgs/acc5f7b";
    # ba45a55 - The last stable update of PHP 7.4
    nixpkgs-ba45a55.url = "github:nixos/nixpkgs/ba45a55";
    # 11ff7 - Oracle JDK 8
    # nixpkgs-11ff7.url = "nixpkgs/b70a4436c617de1576c56b85c8338b5b51c18994";
    # ba6292f - msodbcsql17 v 17.5.1.1
    # nixpkgs-ba6292f.url = "github:nixos/nixpkgs/ba6292f";
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:mic92/sops-nix";
    };
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, home-manager, nixos-hardware, nixpkgs, nixpkgs-acc5f7b, nixpkgs-ba45a55, sops-nix, unstable }:
  let
    channels = {
      home-manager = import home-manager {
        inherit config system;
      };
      nixos-hardware = import nixos-hardware {
        inherit config system;
      };
      nixpkgs = import nixpkgs {
        inherit config system;
      };
      nixpkgs-acc5f7b = import nixpkgs-acc5f7b {
        inherit config system;
      };
      nixpkgs-ba45a55 = import nixpkgs-ba45a55 {
        inherit config system;
      };
      sops-nix = import sops-nix {
        inherit config system;
      };
      unstable = import unstable {
        inherit config system;
      };
    };
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "openssl-1.1.1v"
      ];
    };
    nixosModules = import ./modules;
    overlays = import ./overlays { inherit channels; };
    pkgs = import nixpkgs { inherit config overlays system; };
    system = "x86_64-linux";
  in
  {
    inherit nixosModules;
    nixosConfigurations = {
      "e105-laptop" = nixpkgs.lib.nixosSystem {
        inherit pkgs system;
        modules = [
          ./systems/e105-laptop
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              sharedModules = [
                sops-nix.homeManagerModules.sops
              ];
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
          nixos-hardware.nixosModules.common-gpu-intel
          nixosModules.ironman.user {
            ironman.user.name = "niceastman";
          }
          sops-nix.nixosModules.sops
        ];
      };
      # "ironman-laptop" = lib.nixosSystem {
      #   inherit system;
      #   # suites.nixosModules.personal-apps
      #   # suites.nixosModules.podman
      #   modules = [
      #     nixos-hardware.nixosModules.dell-inspiron-5509
      #     nixos-hardware.nixosModules.common-gpu-intel
      #     self.nixosModules.suites.laptop
      #     ./systems/ironman-laptop
      #   ] ++ self.defaultModules;
      # # ] ++ suites.laptopModules;
      # };
    };
  };
}
