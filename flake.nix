{
  description = "My NixOS Flakes";

  # Our config that sets up systems
  outputs = {self, ...} @ inputs: let
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

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

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

      overlays = with inputs; [flake.overlays.default];

      systems.modules = {
        nixos = with inputs; [
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
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
        e105-laptop.modules = with inputs.nixos-hardware.nixosModules; [
          common-gpu-intel
          system76
        ];
        ironman-laptop.modules = with inputs; [
          nixos-hardware.nixosModules.dell-inspiron-5509
        ];
      };

      alias = {
        shells.default = "ironman-shell";
      };
    };

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  # Sources needed for packages
  # Where possible, I have used flakehub's system as a source for repos
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
    deploy-rs.url = "github:serokell/deploy-rs";
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };
    # Snowfallorg's Flake utility
    flake = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:snowfallorg/flake";
    };
    flake-utils.url = "github:numtide/flake-utils";
    # Home manager to keep track of dotfiles
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-23.11";
    };
    hypridle.url = "github:hyprwm/hypridle";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      inputs.hyprland.follows = "hyprland";
      url = "github:hyprwm/hyprland-plugins";
    };
    hyprlock.url = "github:hyprwm/hyprlock";
    impermanence.url = "github:nix-community/impermanence";
    # Nix-LD is a dynamic linker that tries to mimick FHS file systems for hard-coded applications
    nix-ld = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:mic92/nix-ld";
    };
    # Standard Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-generators = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixos-generators";
    };
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
    plymouth-themes = {
      flake = false;
      url = "github:adi1090x/plymouth-themes";
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
    tmux-sessionx = {
      inputs.nixpkgs.follows = "unstable";
      url = "github:omerxx/tmux-sessionx";
    };
    tochd = {
      flake = false;
      url = "github:ironman820/tochd";
    };
    transparent-nvim = {
      flake = false;
      url = "github:xiyaowong/transparent.nvim";
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
