{
  description = "My NixOS Flakes";

  # Our config that sets up systems
  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;

      channels-config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        permittedInsecurePackages = ["openssl-1.1.1w"];
      };

      snowfall = {
        meta = {
          name = "ironman";
          title = "Ironman Config";
        };
        namespace = "mine";
      };
    };
  in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        permittedInsecurePackages = ["openssl-1.1.1w"];
      };

      overlays = with inputs; [flake.overlays.default];

      systems.modules = {
        nixos = with inputs; [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
          nix-ld.nixosModules.nix-ld
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix
        ];
      };

      systems.hosts = {
        e105-laptop.modules = with inputs; [nixos-hardware.nixosModules.common-gpu-intel];
        ironman-laptop.modules = with inputs; [
          nixos-hardware.nixosModules.dell-inspiron-5509
          nixos-hardware.nixosModules.common-gpu-intel
        ];
      };

      alias = {shells.default = "ironman-shell";};
    };

  # Sources needed for packages
  # Where possible, I have used flakehub's system as a source for repos
  inputs = {
    catppuccin-bat = {
      flake = false;
      url = "github:catppuccin/bat";
    };
    catppuccin-btop = {
      flake = false;
      url = "github:catppuccin/btop";
    };
    # catppuccin theme for grub
    catppuccin-grub = {
      flake = false;
      url = "github:catppuccin/grub";
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
    catppuccin-starship = {
      flake = false;
      url = "github:catppuccin/starship";
    };
    catppuccin-tmux = {
      flake = false;
      url = "github:catppuccin/tmux";
    };
    catppuccin-yazi = {
      flake = false;
      url = "github:uncenter/ctp-yazi";
    };
    cellular-automaton-nvim = {
      flake = false;
      url = "github:eandrju/cellular-automaton.nvim";
    };
    cloak-nvim = {
      flake = false;
      url = "github:laytan/cloak.nvim";
    };
    conceal-nvim = {
      flake = false;
      url = "github:Jxstxs/conceal.nvim";
    };
    # Snowfallorg's Flake utility
    flake = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:snowfallorg/flake";
    };
    flake-utils.url = "https://flakehub.com/f/numtide/flake-utils/0.1.*.tar.gz";
    # Home manager to keep track of dotfiles
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-23.11";
    };
    # Nix-LD is a dynamic linker that tries to mimick FHS file systems for hard-coded applications
    nix-ld = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:mic92/nix-ld";
    };
    # Standard Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # Nixos curated Hardware settings/drivers
    nixos-hardware.url = "github:nixos/nixos-hardware";
    # acc5f7b - IcedTea v8 Stable
    nixpkgs-acc5f7b.url = "github:nixos/nixpkgs/acc5f7b";
    # ba45a55 - The last stable update of PHP 7.4
    nixpkgs-ba45a55.url = "github:nixos/nixpkgs/ba45a55";
    nvim-cmp-nerdfont = {
      flake = false;
      url = "github:chrisgrieser/cmp-nerdfont";
    };
    nvim-undotree = {
      flake = false;
      url = "github:jiaoshijie/undotree";
    };
    obsidian-nvim = {
      flake = false;
      url = "github:epwalsh/obsidian.nvim";
    };
    one-small-step-for-vimkind = {
      flake = false;
      url = "github:jbyuki/one-small-step-for-vimkind";
    };
    ranger-devicons = {
      flake = false;
      url = "github:alexanderjeurissen/ranger_devicons";
    };
    # Catppuccin theme for SDDM
    sddm-catppuccin = {
      flake = false;
      url = "github:catppuccin/sddm";
    };
    snowfall-lib = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:snowfallorg/lib";
    };
    # SOPS Based secret management to encrypt secrets updated to Github
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
    stylix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:danth/stylix/release-23.11";
    };
    tmux-cheat-sh = {
      flake = false;
      url = "github:ironman820/tmux-cheat-sh";
    };
    tmux-fzf-url = {
      flake = false;
      url = "github:wfxr/tmux-fzf-url";
    };
    tmux-session-wizard = {
      flake = false;
      url = "github:27medkamal/tmux-session-wizard";
    };
    tochd = {
      flake = false;
      url = "github:ironman820/tochd";
    };
    # Unstable repo for latest and greatest packages
    unstable.url = "github:NixOS/nixpkgs";
    waybar.url = "github:alexays/waybar";
    yanky-nvim = {
      flake = false;
      url = "github:gbprod/yanky.nvim";
    };
  };
}
