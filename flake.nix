{
  description = "My Nix Flakes";

  inputs = {
    # agenix.url = "github:ryantm/agenix";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      channels-config.allowUnfree = true;

      overlays = with inputs; [
        flake.overlay
      ];

      systems.modules = with inputs; [
        home-manager.nixosModules.home-manager
      ];

      systems.hosts.ironman-laptop.modules = with inputs; [
        nixos-hardware.nixosModules.dell-inspiron-5509
      ];
    };

}