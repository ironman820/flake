{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.boot.systemd;
in {
  options.ironman.boot.systemd = with types; {
    enable = mkBoolOpt (!config.ironman.boot.grub.enable) "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        grub = disabled;
        systemd-boot = enabled;
      };
      plymouth = disabled;
    };
  };
}
