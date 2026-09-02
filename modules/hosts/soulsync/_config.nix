{ config, ... }: {
  hardware.facter.reportPath = ./facter.json;
  networking = {
    hostName = "soulsync";
    nameservers = [
      "192.168.248.2"
    ];
  };
  topology = {
    id = "soulsync";
    self = {
      interfaces.eth0 = {
        addresses = [
          "192.168.248."
        ];
        network = "home";
        physicalConnections = [
          (config.lib.topology.mkConnection "pve" "vmbr0")
        ];
      };
      deviceType = "nixos";
      guestType = "nixos-container";
      name = "SoulSync";
      parent = "pve";
    };
  };
}
