{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.home.sync;
in {
  options.ironman.home.sync = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    services.syncthing = mkIf (cfg.enable) enabled;
  };
}
