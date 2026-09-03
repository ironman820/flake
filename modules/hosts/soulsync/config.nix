{ self, ... }: {
  flake.nixosModules.soulsyncConfig = { config, ... }: {
    hardware.facter.reportPath = ./facter.json;
    networking = {
      hostName = "soulsync";
      nameservers = [
        "192.168.248.2"
      ];
    };
    services.syncthing = {
      enable = true;
      relay.enable = true;
      group = config.ironman.user.name;
      guiAddress = "0.0.0.0:8384";
      guiPasswordFile = config.sops.secrets.syncthing_password.path;
      settings = {
        devices = {
          friday = {
            id = "C2T72DJ-35SQ4DJ-OTQFZUH-R54J3FK-7K2M46K-RAN5SFU-4Y4ZNIL-FZ64AQQ";
            name = "Friday";
          };
          wednesday = {
            id = "ICGQ6GR-GFFLBJB-N4AF3AP-IOSLCHN-337F5UX-RW2A35G-UZ3Q2N4-SVWXTQY";
            name = "Wednesday";
          };
        };
        folders = {

        };
        options.urAccepted = -1;
      };
      user = config.ironman.user.name;
    };
    sops.secrets.syncthing_password = {
      owner = config.ironman.user.name;
      sopsFile = "${self.outPath}/.secrets/syncthing.yaml";
      group = config.ironman.user.name;
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
  };
}
