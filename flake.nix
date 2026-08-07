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
    kineticwe = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:theblackdon/kineticwe";
    };
    millennium = {
      url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:epireyn/niri-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
    };
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
    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    # Keep Noctalia using it's own nixpkgs. This allows cache usage.
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
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
    wrapper-modules = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:birdeehub/nix-wrapper-modules";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
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
        imports = with inputs; [
          disko.flakeModules.default
          easy-hosts.flakeModule
          home-manager.flakeModules.home-manager
          (import-tree ./modules)
          nix-topology.flakeModule
          pkgs-by-name.flakeModule
        ];
        systems = [
          "x86_64-linux"
        ];
      }
    );
}
