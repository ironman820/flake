{
  description = "My Nix Flakes";

  inputs = {
    flake = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:snowfallorg/flake";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "home-manager/release-23.05";
    };
    nixos-hardware.url = "nixos-hardware";
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-acc5f7b.url = "nixpkgs/acc5f7b";
    # nixpkgs-11ff7.url = "nixpkgs/b70a4436c617de1576c56b85c8338b5b51c18994";
    snowfall-lib = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:snowfallorg/lib";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "sops-nix";
    };
    unstable.url = "nixpkgs";
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
        sops-nix.nixosModules.sops
      ];

      systems.hosts.ironman-laptop.modules = with inputs; [
        nixos-hardware.nixosModules.dell-inspiron-5509
      ];
    };
}
