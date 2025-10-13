{
  description = "Ironman820's configuration flake";

  outputs =
    { self, ... }@inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      alias = {
        shells.default = "ironman-shell";
      };
      channels-config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        permittedInsecurePackages = [ "openssl-1.1.1w" ];
      };
      checks = builtins.mapAttrs (
        system: deployLib: deployLib.deployChecks self.deploy
      ) inputs.deploy-rs.lib;

      deploy.nodes = {
        pxe-work = {
          hostname = "pxe.desk";
          fastConnection = true;
          interactiveSudo = false;
          profiles.system = {
            sshUser = "ironman";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.pxe-work;
            user = "root";
          };
        };
        rcm-work = {
          hostname = "rcm.desk";
          fastConnection = true;
          interactiveSudo = false;
          profiles.system = {
            sshUser = "ironman";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.rcm-work;
            user = "root";
          };
        };
      };
      overlays = with inputs; [ snowfall-flake.overlays."package/flake" ];
      snowfall = {
        namespace = "mine";
        meta = {
          name = "ironman-config";
          title = "Ironman's Config";
        };
      };
      systems.hosts = {
        e105-laptop.modules = with inputs.nixos-hardware.nixosModules; [
          common-gpu-intel
          system76
        ];
        friday.modules = with inputs; [
          nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
        ];
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
    catppuccin-bat = {
      flake = false;
      url = "github:catppuccin/bat";
    };
    catppuccin-btop = {
      flake = false;
      url = "github:catppuccin/btop";
    };
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
    deploy-rs = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:serokell/deploy-rs";
    };
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      inputs.nixpkgs.follows = "unstable";
      url = "github:nix-community/home-manager/release-25.05";
    };
    neovim = {
      inputs.nixpkgs.follows = "unstable";
      url = "github:ironman820/neovim/updates";
    };
    nixos-generators = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixos-generators";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # acc5f7b - IcedTea v8 Stable
    nixpkgs-acc5f7b.url = "github:nixos/nixpkgs/acc5f7b";
    # ba45a55 - The last stable update of PHP 7.4
    nixpkgs-ba45a55.url = "github:nixos/nixpkgs/6e3a86f";
    nvim-undotree = {
      flake = false;
      url = "github:jiaoshijie/undotree";
    };
    obsidian-nvim = {
      flake = false;
      url = "github:epwalsh/obsidian.nvim";
    };
    plymouth-themes = {
      flake = false;
      url = "github:adi1090x/plymouth-themes";
    };
    ranger-devicons = {
      flake = false;
      url = "github:alexanderjeurissen/ranger_devicons";
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
    tochd = {
      flake = false;
      url = "github:ironman820/tochd";
    };
    transparent-nvim = {
      flake = false;
      url = "github:xiyaowong/transparent.nvim";
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
    waybar = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:alexays/waybar";
    };
    yanky-nvim = {
      flake = false;
      url = "github:gbprod/yanky.nvim";
    };
  };
}
