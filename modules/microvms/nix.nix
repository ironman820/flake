{
  flake.nixosModules.microvms-nix = { config, ... }: {
      environment.sessionVariables.NH_FLAKE = "/home/${config.ironman.user.name}/git/flake";
      nix = {
        channel.enable = false;
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
        optimise.automatic = false;
        settings = {
          cores = 1;
          auto-optimise-store = false;
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
      programs = {
        nix-index.enable = true;
        nix-ld.enable = true;
      };
  };
}
