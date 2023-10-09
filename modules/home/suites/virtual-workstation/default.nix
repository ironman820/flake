{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled;
  cfg = config.ironman.home.suites.virtual-workstation;
in {
  options.ironman.home.suites.virtual-workstation = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
      home.file.".config/is_server".text = ''false'';
      ironman.home = {
        gnome = enabled;
        sync = enabled;
      };
  };
}
