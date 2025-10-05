{
  description = "A not-so basic flake";

  outputs =
    inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      channels-config.allowUnfree = true;
      overlays = with inputs; [ snowfall-flake.overlays."package/flake" ];
      snowfall = {
        namespace = "mine";
        meta = {
          name = "ironman-config";
          title = "Ironman's Config";
        };
      };
      systems.modules.nixos = with inputs; [
        disko.nixosModules.disko
        neovim.nixosModules.default
        sops-nix.nixosModules.sops
        stylix.nixosModules.stylix
      ];
    };

  inputs = {
    base16-schemes = {
      flake = false;
      url = "github:tinted-theming/base16-schemes";
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
    catppuccin-neomutt = {
      flake = false;
      url = "github:catppuccin/neomutt";
    };
    catppuccin-rofi = {
      flake = false;
      url = "github:catppuccin/rofi";
    };
    conceal-nvim = {
      flake = false;
      url = "github:Jxstxs/conceal.nvim";
    };
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-25.05";
    };
    neovim = {
      inputs.nixpkgs.follows = "unstable";
      url = "github:ironman820/neovim/updates";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nvim-cmp-nerdfont = {
      flake = false;
      url = "github:chrisgrieser/cmp-nerdfont";
    };
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "unstable";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # SOPS Based secret management to encrypt secrets updated to Github
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
    stylix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:danth/stylix/release-25.05";
    };
    tmux-cheat-sh = {
      flake = false;
      url = "github:ironman820/tmux-cheat-sh";
    };
    tmux-sessionx = {
      inputs.nixpkgs.follows = "unstable";
      url = "github:omerxx/tmux-sessionx";
    };
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };
}
