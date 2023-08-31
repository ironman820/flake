{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.boot.systemd;
in {
  options.ironman.boot.systemd = with types; {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
  };
}
