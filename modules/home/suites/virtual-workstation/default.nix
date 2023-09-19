{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.home.suites.virtual-workstation;
in {
  options.ironman.home.suites.virtual-workstation = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
      home.file.".config/is_server".text = ''false'';
      ironman.home = {
        gnome = enabled;
        sync = enabled;
      };
  };
}
