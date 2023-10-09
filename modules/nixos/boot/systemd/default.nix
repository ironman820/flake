{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.ironman) disabled enabled mkBoolOpt;
  cfg = config.ironman.boot.systemd;
in {
  options.ironman.boot.systemd = {
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
