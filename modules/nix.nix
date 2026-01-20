{
  flake.nixosModules.nix =
    {
      config,
      inputs,
      lib,
      ...
    }:
    let
      inherit (lib) mkDefault;
    in
    {
      environment.sessionVariables.NH_FLAKE = "/home/${config.ironman.user.name}/git/flake";
      nix = {
        channel.enable = false;
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
        optimise.automatic = true;
        settings = {
          cores = mkDefault 1;
          auto-optimise-store = true;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "root"
            "@wheel"
          ];
        };
      };
      nixpkgs = {
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "googleearth-pro-7.3.6.10201"
            "openssl-1.1.1w"
          ];
        };
        overlays = [
          inputs.self.overlays.default
        ];
      };
      programs = {
        nh = {
          enable = true;
          flake = "/home/${config.ironman.user.name}/git/flake";
        };
        nix-index.enable = true;
        nix-ld.enable = true;
      };
    };
}
