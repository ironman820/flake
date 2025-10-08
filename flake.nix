{
  description = "Ironman820's master flake";

  # outputs =
  #   inputs:
  #   inputs.snowfall-lib.mkFlake {
  #     systems.hosts = {
  #       e105-laptop.modules = with inputs; [
  #         nixos-hardware.nixosModules.system76
  #       ];
  #     };
  #     systems.modules.nixos = with inputs; [
  #       neovim.nixosModules.default
  #       stylix.nixosModules.stylix
  #     ];
  #   };

  outputs =
    inputs@{ flake-parts, ... }:
    # https://flake.parts/module-arguments.html
    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      let
        inherit (lib) nixosSystem;

        lib = inputs.nixpkgs.lib.extend (final: prev: { mine = import ./modules/lib { lib = prev; }; });
      in
      {
        imports = [
          # Optional: use external flake logic, e.g.
          # inputs.foo.flakeModules.default
        ];
        flake = rec {
          nixosConfigurations = {
            friday = withSystem "x86_64-linux" (
              { system, self', ... }:
              nixosSystem {
                specialArgs = {
                  inherit system self';
                };
                modules = ([
                  nixosModules.default
                  ./systems/friday
                ])
                ++ (with inputs; [
                  disko.nixosModules.disko
                  nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
                  sops-nix.nixosModules.sops
                ]);
              }
            );
          };
          nixosModules.default =
            { ... }:
            {
              imports = [
                ./modules/networking
                ./modules/user
              ];
            };
        };
        systems = [
          # systems for which you want to build the `perSystem` attributes
          "x86_64-linux"
          # ...
        ];
        perSystem =
          { config, pkgs, ... }:
          {
            # Recommended: move all package definitions here.
            # e.g. (assuming you have a nixpkgs input)
            # packages.foo = pkgs.callPackage ./foo/package.nix { };
            # packages.bar = pkgs.callPackage ./bar/package.nix {
            #   foo = config.packages.foo;
            # };
            packages.catppuccin-kitty = pkgs.callPackage ./packages/catppuccin-kitty { inherit inputs pkgs; };
          };
      }
    );

  inputs = {
    # base16-schemes = {
    #   flake = false;
    #   url = "github:tinted-theming/base16-schemes";
    # };
    # catppuccin-btop = {
    #   flake = false;
    #   url = "github:catppuccin/btop";
    # };
    catppuccin-kitty = {
      flake = false;
      url = "github:catppuccin/kitty";
    };
    # catppuccin-lazygit = {
    #   flake = false;
    #   url = "github:catppuccin/lazygit";
    # };
    # catppuccin-neomutt = {
    #   flake = false;
    #   url = "github:catppuccin/neomutt";
    # };
    # catppuccin-rofi = {
    #   flake = false;
    #   url = "github:catppuccin/rofi";
    # };
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    # home-manager = {
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   url = "github:nix-community/home-manager/release-25.05";
    # };
    # neovim = {
    #   inputs.nixpkgs.follows = "unstable";
    #   url = "github:ironman820/neovim/updates";
    #   # url = "/home/ironman/git/neovim";
    # };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # snowfall-flake = {
    #   url = "github:snowfallorg/flake";
    #   inputs.nixpkgs.follows = "unstable";
    # };
    # snowfall-lib = {
    #   url = "github:snowfallorg/lib";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # SOPS Based secret management to encrypt secrets updated to Github
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
    # stylix = {
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   url = "github:danth/stylix/release-25.05";
    # };
    # tmux-cheat-sh = {
    #   flake = false;
    #   url = "github:ironman820/tmux-cheat-sh";
    # };
    # tmux-sessionx = {
    #   inputs.nixpkgs.follows = "unstable";
    #   url = "github:omerxx/tmux-sessionx";
    # };
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };
}
