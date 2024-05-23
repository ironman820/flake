{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) disabled enabled;

  cfg = config.mine.hardware.power;
in {
  options.mine.hardware.power = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    powerManagement = {
      enable = true;
      powertop = enabled;
    };
    services = {
      power-profiles-daemon = disabled;
      system76-scheduler.settings.cfsProfiles = enabled;
      thermald = enabled;
      tlp = {
        enable = true;
        settings = {
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          SATA_LINKPWR_ON_BAT = "med_power_with_dipm min_power";
          WIFI_PWR_ON_AC = "off";
          WIFI_PWR_ON_BAT = "off";
        };
      };
    };
  };
}
