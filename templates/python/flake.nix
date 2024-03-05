{
  description = "My NixOS Flakes";

  # Our config that sets up systems
  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./nix;

      channels-config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
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
      };

      overlays = with inputs; [flake.overlays.default];

      alias = {shells.default = "ironman-shell";};
    };

  # Sources needed for packages
  # Where possible, I have used flakehub's system as a source for repos
  inputs = {
    # Snowfallorg's Flake utility
    flake = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:snowfallorg/flake";
    };
    flake-utils.url = "https://flakehub.com/f/numtide/flake-utils/0.1.*.tar.gz";
    # Standard Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    snowfall-lib = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:snowfallorg/lib";
    };
    # SOPS Based secret management to encrypt secrets updated to Github
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
    # Unstable repo for latest and greatest packages
    unstable.url = "github:NixOS/nixpkgs";
  };
}
