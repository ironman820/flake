{ config, lib, options, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.home.suites.server.rcm2;
in
{
  options.ironman.home.suites.server.rcm2 = with types; {
    enable = mkBoolOpt false "Enable the suite";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      "cover" = "coverage run && coverage xml && coverage html";
    };
    programs.git.extraConfig.safe.directory = "/data/rcm";
  };
}
