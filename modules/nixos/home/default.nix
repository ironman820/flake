{ options, pkgs, config, lib, inputs, ... }:
let
  inherit (lib) mkAliasDefinitions mkIf;
  inherit (lib.ironman) mkBoolOpt mkOpt;
  inherit (lib.types) attrs;
  cfg = config.ironman.home;
in
{
  options.ironman.home = {
    enable = mkBoolOpt true "Setup home-manager";
    file = mkOpt attrs { } "Files that need added to the home manager's file settings.";
    extraOptions = mkOpt attrs { } "Extra attributes to add to the home config.";
  };

  config.home-manager = mkIf cfg.enable {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${config.ironman.user.name} =
      mkAliasDefinitions options.ironman.home.extraOptions;
  };
}
