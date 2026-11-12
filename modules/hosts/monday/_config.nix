{ config, ... }: {
  boot.plymouth.enable = false;
  # hardware.facter.reportPath = ./facter.json;
  ironman.network-profiles.work = true;
  networking.hostName = "monday";
  topology.self = {
    hardware.info = "Dell Netbook";
    icon = "devices.laptop";
    interfaces.wlp1s0 = {
      network = "home";
      physicalConnections = [
        (config.lib.topology.mkConnection "ap" "wifi2")
      ];
      renderer.hidePhysicalConnections = true;
    };
    name = "Monday";
  };
  zramSwap.enable = false;
}
