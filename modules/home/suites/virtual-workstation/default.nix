{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled;
  cfg = config.ironman.home.suites.virtual-workstation;
in {
  options.ironman.home.suites.virtual-workstation = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
      ironman.home = {
        gnome = enabled;
        sync = enabled;
      };
  };
}
