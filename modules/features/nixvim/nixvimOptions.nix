{
  flake.nixosModules.nixvimOptions =
    {
      lib,
      ...
    }:
    {
      options.ironman.neovimPkg = lib.mkOption {
        default = true;
        description = "Wheather this is the standalone package (true) or in a module (false)";
        type = lib.types.bool;
      };

      config = { };
    };
}
