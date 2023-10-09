{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled;
  cfg = config.ironman.home.suites.workstation;
in
{
  options.ironman.home.suites.workstation = {
    enable = mkEnableOption "Enable the default settings?";
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
