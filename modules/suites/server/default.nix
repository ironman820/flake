{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.suites.server;
in {
  options.ironman.suites.server = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    ironman = {
      # firmware = enabled;
    };
  };
}
