{ config, ... }: {
  hardware.facter.reportPath = ./facter.json;
  ironman = {
    sync = true;
    syncthing = {
      devices = {
        friday = {
          id = "C2T72DJ-35SQ4DJ-OTQFZUH-R54J3FK-7K2M46K-RAN5SFU-4Y4ZNIL-FZ64AQQ";
          name = "Friday";
        };
        wednesday.id = "ICGQ6GR-GFFLBJB-N4AF3AP-IOSLCHN-337F5UX-RW2A35G-UZ3Q2N4-SVWXTQY";
      };
    };
  };
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
          "192.168.248.119"
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
