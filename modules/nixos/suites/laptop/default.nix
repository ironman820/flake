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
    mine = {
      hardware = {
        bluetooth = enabled;
        power = enabled;
      };
      firmware = enabled;
      suites.workstation = enabled;
      networking.profiles = enabled;
    };
    services.logind = {
      killUserProcesses = true;
      lidSwitchExternalPower = "ignore";
    };
  };
}
