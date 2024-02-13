{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled;
  cfg = config.ironman.home.sync;
in {
  options.ironman.home.sync = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    services.syncthing = enabled;
  };
}
