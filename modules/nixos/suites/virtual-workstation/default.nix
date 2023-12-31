{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.suites.virtual-workstation;
in {
  options.ironman.suites.virtual-workstation = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    ironman = {
      gnome = enabled;
      sync = enabled;
      sops = enabled;
      virtual.guest = enabled;
    };
    powerManagement.cpuFreqGovernor = "performance";
    security.sudo.wheelNeedsPassword = false;
    zramSwap = {
      enable = true;
      memoryPercent = 90;
    };
  };
}
