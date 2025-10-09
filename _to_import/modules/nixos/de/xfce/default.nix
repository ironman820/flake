{
  lib,
  options,
  config,
  ...
}: let
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf types;
  inherit (lib.mine) enabled mkBoolOpt mkOpt;
  inherit (lib.types) listOf;

  cfg = config.mine.de.xfce;
in {
  options.mine.de.xfce = {
    enable = mkEnableOption "Enable the module";
    enableScreensaver = mkBoolOpt true "Enable screensaver";
    excludePackages = mkOpt (listOf types.pkgs) [] "List of packages to exclude";
  };
  config = mkIf cfg.enable {
    mine.gui-apps.thunar = enabled;
    environment.xfce.excludePackages = mkAliasDefinitions options.mine.xfce.excludePackages;
    services.xserver.desktopManager.xfce = {
      inherit (cfg) enable enableScreensaver;
    };
  };
}
