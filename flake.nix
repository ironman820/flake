{
  inputs = {
    arion = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:hercules-ci/arion";
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
    flake-parts.url = "github:hercules-ci/flake-parts";
    hexecute = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ThatOtherAndrew/Hexecute";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Nixpkgs for glocom
    nixpkgs-8cad3db.url = "github:nixos/nixpkgs/8cad3db";
    # openssh v9
    nixpkgs-openssh.url = "github:nixos/nixpkgs/336eda0";
    # PHP 7.2.29
    nixpkgs-php.url = "github:nixos/nixpkgs/53951c0";
    nixpkgs-9041993.url = "github:nixos/nixpkgs/9041993";
    nixvim = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/nixvim";
    };
    pkgs-by-name.url = "github:drupol/pkgs-by-name-for-flake-parts";
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
