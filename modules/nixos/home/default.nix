{ options, pkgs, config, lib, inputs, ... }:

with lib;
with lib.ironman;
# with lib.internal;
let
  cfg = config.ironman.home;
in
{
  options.ironman.home = with types; {
    file = mkOpt attrs { } "Files that need added to the home manager's file settings.";
    extraOptions = mkOpt attrs { } "Extra attributes to add to the home config.";
  };

  config.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${config.ironman.user.name} =
      mkAliasDefinitions options.ironman.home.extraOptions;
  };
}
