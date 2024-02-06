{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled;
  cfg = config.mine.suites.laptop;
in {
  options.mine.suites.laptop = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = enabled;
    mine = {
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
