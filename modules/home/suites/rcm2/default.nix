{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.suites.server.rcm2;
in
{
  options.mine.home.suites.server.rcm2 = {
    enable = mkEnableOption "Enable the suite";
  };

  config = mkIf cfg.enable {
    programs.git.extraConfig.safe.directory = "/data/rcm";
  };
}
