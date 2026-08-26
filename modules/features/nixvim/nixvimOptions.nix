{
  flake = {
    nixosModules.nixvimOptions =
      {
        lib,
        ...
      }:
      with lib;
      {
        options.ironman.neovimPkg = mkOption {
          default = true;
          description = "Wheather this is the standalone package (true) or in a module (false)";
          type = types.bool;
        };

        config = { };
      };
    homeModules.nixvimOptions =
      {
        lib,
        ...
      }:
      with lib;
      {
        options.ironman.neovimPkg = mkOption {
          default = true;
          description = "Wheather this is the standalone package (true) or in a module (false)";
          type = types.bool;
        };

        config = { };
      };
  };
}
