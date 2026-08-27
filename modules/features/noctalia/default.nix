{
  inputs,
  ...
}:
{
  flake = {
    nixosModules.noctalia = {
      imports = [
        inputs.noctalia.nixosModules.default
      ];
      programs.noctalia = {
        enable = true;
        recommendedServices.enable = true;
      };
    };
    homeModules.noctalia = {
      imports = [
        inputs.noctalia.homeModules.default
      ];
      programs.noctalia = {
        enable = true;
        settings = ./noctalia.toml;
      };
    };
  };
}
