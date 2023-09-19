{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.home.suites.workstation;
in
{
  options.ironman.home.suites.workstation = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    ironman.home = {
      gnome = enabled;
      gui-apps = enabled;
      sync = enabled;
      video-tools = enabled;
      virtual.host = enabled;
      yubikey = enabled;
    };
    home.file.".config/is_server".text = ''false'';
  };
}
