{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;
  cfg = config.mine.home.suites.virtual-workstation;
in {
  options.mine.home.suites.virtual-workstation = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    mine.home = {
      gnome = enabled;
      sync = enabled;
    };
  };
}
