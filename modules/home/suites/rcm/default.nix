{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.home.suites.server.rcm;
in
{
  options.ironman.home.suites.server.rcm = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    programs.git.extraConfig.safe.directory = "/data/rcm";
  };
}
