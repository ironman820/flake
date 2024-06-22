{
  cell,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
in {
  powerManagement = {
    enable = true;
    powertop = l.enabled;
  };
  services = {
    power-profiles-daemon = l.disabled;
    # system76-scheduler.settings.cfsProfiles = l.enabled;
    thermald = l.enabled;
    tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        SATA_LINKPWR_ON_BAT = "medium_power";
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "off";
      };
    };
  };
}
