{
  inputs = {
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };
    facter-modules.url = "github:nix-community/nixos-facter-modules";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    import-tree.url = "github:vic/import-tree";
    neovim = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ironman820/neovim/updates";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:mic92/sops-nix";
    };
  };
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      top@{ self, ... }:
      {
        _module.args = {
          inherit inputs;
          flakeRoot = self.outPath;
        };
        imports = [
          (inputs.import-tree ./modules)
        ];
      }
    );
}
