# Revisions:

{
  inputs = {
    arion = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:hercules-ci/arion";
    };
    bonafides-themes = {
      flake = false;
      url = "github:l4ki/bonafides-plasma-themes";
    };
    catppuccin-btop = {
      flake = false;
      url = "github:catppuccin/btop";
    };
    catppuccin-kitty = {
      flake = false;
      url = "github:catppuccin/kitty";
    };
    catppuccin-lazygit = {
      flake = false;
      url = "github:catppuccin/lazygit";
    };
    # Crane for rcm2 djc-core-html package
    crane = {
      url = "github:ipetkov/crane";
    };
    darkmatter-grub-theme = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:vandalbyte/darkmatter-grub-theme";
    };
    deploy-rs = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:serokell/deploy-rs";
    };
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };
    easy-hosts.url = "github:tgirlcloud/easy-hosts";
    elephant = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:abenz1267/elephant";
    };
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "github:hercules-ci/flake-parts";
    };
    hexecute = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ThatOtherAndrew/Hexecute";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nixos-hardware = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:NixOS/nixos-hardware/master";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Nixpkgs for glocom
    nixpkgs-8cad3db.url = "github:nixos/nixpkgs/8cad3db";
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
    # openssh v9
    nixpkgs-openssh.url = "github:nixos/nixpkgs/0858160";
    # PHP 7.2.29
    nixpkgs-php.url = "github:nixos/nixpkgs/53951c0";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    # nVidia 575.64
    nixpkgs-9041993.url = "github:nixos/nixpkgs/9041993";
    # nVidia 580.95.05
    nixpkgs-3652b3e.url = "github:nixos/nixpkgs/3652b3e";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pkgs-by-name.url = "github:drupol/pkgs-by-name-for-flake-parts";
    plasma-manager = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
      url = "github:nix-community/plasma-manager";
    };
    # Rust Overlays for rcm2 djc-core-html package
    rust-overlay = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:oxalica/rust-overlay";
    };
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:mic92/sops-nix";
    };
    stable.url = "github:nixos/nixpkgs/nixos-25.05";
    tokyonight = {
      flake = false;
      url = "github:folke/tokyonight.nvim";
    };
    walker = {
      inputs = {
        elephant.follows = "elephant";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:abenz1267/walker";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { self, ... }:
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
