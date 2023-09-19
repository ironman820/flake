{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.home.suites.servers.rcm;
in
{
  options.ironman.home.suites.servers.rcm = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    programs.git.extraConfig.safe.directory = "/data/rcm";
  };
}
