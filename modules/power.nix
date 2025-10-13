{
  flake.nixosModules.power = _: {
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };
    services = {
      power-profiles-daemon.enable = false;
      thermald.enable = true;
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
