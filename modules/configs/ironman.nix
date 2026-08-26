{
  flake = {
    nixosModules.ironman =
      { lib, ... }:
      with lib;
      {
        options.ironman.laptop = mkOption {
          default = false;
          description = "Is this system a laptop?";
          type = types.bool;
        };
      };
    homeModules.ironman = {
    };
  };
}
