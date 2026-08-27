{
  flake = {
    nixosModules.nixvimOptions =
      {
        lib,
        ...
      }:
      let
        inherit (lib) mkOption types;
      in
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
      let
        inherit (lib) mkOption types;
      in
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
