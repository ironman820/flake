{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.suites.virtual-workstation;
in {
  options.ironman.suites.virtual-workstation = with types; {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    ironman.home.extraOptions.home.file = {
      ".config/is_server".text = ''false'';
    };
    powerManagement.cpuFreqGovernor = "performance";
    security.sudo.wheelNeedsPassword = false;
    zramSwap = {
      enable = true;
      memoryPercent = 90;
    };
  };
}
