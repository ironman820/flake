{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.home.suites.server;
in
{
  options.ironman.home.suites.server = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    home.file.".config/is_server".text = ''true'';
  };
}
