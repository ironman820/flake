{
  description = "My Nix Flakes";

  inputs = {
    # agenix = {
    #   url = "github:ryantm/agenix";
    # };
    flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix-alien.url = "github:thiagokokada/nix-alien";
    # nix-ld = {
    #   url = "github:Mic92/nix-ld";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      channels-config.allowUnfree = true;

      overlays = with inputs; [
        flake.overlays.default
      ];

      systems.modules = with inputs; [
        home-manager.nixosModules.home-manager
      ];

      systems.hosts.ironman-laptop.modules = with inputs; [
        # agenix.nixosModules.default
        nixos-hardware.nixosModules.dell-inspiron-5509
      ];
    };

}
