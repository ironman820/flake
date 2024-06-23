{
  description = "My NixOS Flakes";

  outputs = {
    self,
    std,
    hive,
    ...
  } @ inputs: let
    inherit (inputs.nixpkgs) lib;
    myCollect =
      hive.collect
      // {
        renamer = cell: target: "${target}";
      };
  in
    hive.growOn {
      inherit inputs;
      cellsFrom = ./cells;
      cellBlocks = with (lib.mergeAttrsList [
        hive.blockTypes
        std.blockTypes
      ]); [
        (functions "bee")
        (functions "hardwareProfiles")
        (functions "homeProfiles")
        (functions "homeSuites")
        (functions "lib")
        (functions "nixosProfiles")
        (functions "nixosSuites")
        (pkgs "overlays")
        (installables "packages")
        (devshells "shell")
        colmenaConfigurations
        diskoConfigurations
        nixosConfigurations
      ];
    }
    {
      devShells = std.harvest self ["mine" "shell"];
      packages = std.harvest self [
        ["grub-cyberexs" "packages"]
        ["idracclient" "packages"]
        ["mine" "packages"]
      ];
    }
    {
      colmenaHive = myCollect self "colmenaConfigurations";
      diskoConfigurations = myCollect self "diskoConfigurations";
      nixosConfigurations = myCollect self "nixosConfigurations";
    };
  # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
  #
  # deploy.nodes = {
  #   pxe-work = {
  #     hostname = "pxe.desk";
  #     fastConnection = true;
  #     interactiveSudo = false;
  #     profiles.system = {
  #       sshUser = "ironman";
  #       path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.pxe-work;
  #       user = "root";
  #     };
  #   };
  #   rcm-work = {
  #     hostname = "rcm.desk";
  #     fastConnection = true;
  #     interactiveSudo = false;
  #     profiles.system = {
  #       sshUser = "ironman";
  #       path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.rcm-work;
  #       user = "root";
  #     };
  #   };
  # };
  #
  # overlays = with inputs; [flake.overlays.default];
  #
  # systems.hosts = {
  #   e105-laptop.modules = with inputs.nixos-hardware.nixosModules; [
  #     common-gpu-intel
  #     system76
  #   ];
  # };

  # Sources needed for packages
  # Where possible, I have used flakehub's system as a source for repos
  inputs = {
    # base16-schemes = {
    #   flake = false;
    #   url = "github:tinted-theming/base16-schemes";
    # };
    # catppuccin-neomutt = {
    #   flake = false;
    #   url = "github:catppuccin/neomutt";
    # };
    # cellular-automaton-nvim = {
    #   flake = false;
    #   url = "github:eandrju/cellular-automaton.nvim";
    # };
    # cloak-nvim = {
    #   flake = false;
    #   url = "github:laytan/cloak.nvim";
    # };
    colmena = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:zhaofengli/colmena";
    };
    conceal-nvim = {
      flake = false;
      url = "github:Jxstxs/conceal.nvim";
    };
    # deploy-rs.url = "github:serokell/deploy-rs";
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };
    # flake-utils.url = "github:numtide/flake-utils";
    hive = {
      inputs = {
        colmena.follows = "colmena";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:divnix/hive";
    };
    # Home manager to keep track of dotfiles
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    # hypridle.url = "github:hyprwm/hypridle";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # hyprland-plugins = {
    #   inputs.hyprland.follows = "hyprland";
    #   url = "github:hyprwm/hyprland-plugins";
    # };
    # hyprlock.url = "github:hyprwm/hyprlock";
    ironman-dwm = {
      flake = false;
      url = "github:ironman820/ironman-dwm";
    };
    # Nix-LD is a dynamic linker that tries to mimick FHS file systems for hard-coded applications
    nix-ld = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:mic92/nix-ld";
    };
    # nixos-generators = {
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   url = "github:nix-community/nixos-generators";
    # };
    # Nixos curated Hardware settings/drivers
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.follows = "nixpkgs-unstable";
    # # acc5f7b - IcedTea v8 Stable
    # nixpkgs-acc5f7b.url = "github:nixos/nixpkgs/acc5f7b";
    # # ba45a55 - The last stable update of PHP 7.4
    # nixpkgs-ba45a55.url = "github:nixos/nixpkgs/ba45a55";
    nixpkgs-2311.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      inputs = {
        devshell.follows = "hive/devshell";
        flake-compat.follows = "colmena/flake-compat";
        home-manager.follows = "home-manager";
        nix-darwin.follows = "hive/std/blank";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/nixvim";
    };
    nvim-cmp-nerdfont = {
      flake = false;
      url = "github:chrisgrieser/cmp-nerdfont";
    };
    nvim-undotree = {
      flake = false;
      url = "github:jiaoshijie/undotree";
    };
    # obsidian-nvim = {
    #   flake = false;
    #   url = "github:epwalsh/obsidian.nvim";
    # };
    one-small-step-for-vimkind = {
      flake = false;
      url = "github:jbyuki/one-small-step-for-vimkind";
    };
    # plymouth-themes = {
    #   flake = false;
    #   url = "github:adi1090x/plymouth-themes";
    # };
    quick-nix-registry = {
      url = "github:divnix/quick-nix-registry";
    };
    # ranger-devicons = {
    #   flake = false;
    #   url = "github:alexanderjeurissen/ranger_devicons";
    # };
    # SOPS Based secret management to encrypt secrets updated to Github
    sops-nix = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
      url = "github:Mic92/sops-nix";
    };
    std.follows = "hive/std";
    tmux-cheat-sh = {
      flake = false;
      url = "github:ironman820/tmux-cheat-sh";
    };
    tmux-fzf-url = {
      flake = false;
      url = "github:wfxr/tmux-fzf-url";
    };
    tmux-sessionx = {
      inputs = {
        flake-parts.follows = "nixvim/flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:omerxx/tmux-sessionx";
    };
    tochd = {
      flake = false;
      url = "github:thingsiplay/tochd";
    };
    # transparent-nvim = {
    #   flake = false;
    #   url = "github:xiyaowong/transparent.nvim";
    # };
    # waybar.url = "github:alexays/waybar";
    # yanky-nvim = {
    #   flake = false;
    #   url = "github:gbprod/yanky.nvim";
    # };
  };
}
