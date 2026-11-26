{
  flake.nixosModules.bazarr =
    { config, ... }:
    let
      inherit (config.ironman.servers.bazarr) user;
    in
    {
      services.bazarr = {
        inherit user;
        enable = true;
        group = user;
      };
    };
}
