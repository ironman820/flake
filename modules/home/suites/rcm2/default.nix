{ config, lib, options, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.home.suites.server.rcm2;
in
{
  options.ironman.home.suites.server.rcm2 = {
    enable = mkEnableOption "Enable the suite";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      "cover" = "coverage run && coverage xml && coverage html";
    };
    programs.git.extraConfig.safe.directory = "/data/rcm";
  };
}
