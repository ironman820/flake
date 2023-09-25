{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.suites.laptop;
in {
  options.ironman.suites.laptop = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = enabled;
    ironman = {
      firmware = enabled;
      intel-video = enabled;
      suites.workstation = enabled;
      vpn = enabled;
      wireless-profiles = enabled;
    };
    services = {
      logind = {
        killUserProcesses = true;
        lidSwitchExternalPower = "ignore";
      };
      xserver.libinput = {
        enable = true;
        touchpad.naturalScrolling = true;
      };
    };
  };
}
