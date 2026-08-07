{
  flake.nixosModules.noctalia = _: {
    programs.noctalia = {
      enable = true;
      recommendedServices.enable = true;
    };
  };
}
