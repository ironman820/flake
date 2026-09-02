{ config, ... }: {
  hardware.facter.reportPath = ./facter.json;
  networking = {
    hostName = "storage";
    nameservers = [
      "192.168.248.2"
    ];
  };
  services = {
    samba = {
      enable = true;
      settings = {
        global = {
          "guest account" = "nobody";
          "hosts allow" = "192.168. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "map to guest" = "bad user";
          security = "user";
          "usershare allow guests" = "yes";
          workgroup = "WORKGROUP";
        };
        data = {
          path = "/shares/data";
          browsable = true;
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = config.ironman.user.name;
          "force group" = config.ironman.user.name;
          "guest ok" = "yes";
          "read only" = "no";
        };
      };
    };
    samba-wsdd.enable = true;
  };
  topology =
    let
      inherit (config.lib.topology) mkConnection;
    in
    {
      id = "storage";
      self = {
        interfaces.eth0 = {
          addresses = [
            "192.168.248.100"
          ];
          network = "home";
          physicalConnections = [
            (mkConnection "pve" "vmbr0")
          ];
        };
        deviceType = "nixos";
        guestType = "nixos-container";
        name = "Storage";
        parent = "pve";
      };
    };
}
