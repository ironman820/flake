{ config, ... }: {
  hardware.facter.reportPath = ./facter.json;
  ironman.slsk.enable = true;
  networking = {
    hostName = "soulseek";
    nameservers = [
      "192.168.248.2"
    ];
  };
  topology =
    let
      inherit (config.lib.topology) mkConnection;
    in
    {
      id = "soulseek";
      self = {
        interfaces.eth0 = {
          addresses = [
            "192.168.248.125"
          ];
          network = "home";
          physicalConnections = [
            (mkConnection "pve" "vmbr0")
          ];
        };
        deviceType = "nixos";
        guestType = "nixos-container";
        name = "SoulSeek";
        parent = "pve";
      };
    };
}
