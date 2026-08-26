{
  flake = {
    nixosModules.direnv = {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
    homeModules.direnv = {
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}
