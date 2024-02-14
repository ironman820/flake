{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;
  cfg = config.mine.home.sync;
in {
  options.mine.home.sync = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    services.syncthing = enabled;
  };
}
