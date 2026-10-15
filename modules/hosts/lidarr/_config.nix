{
  hardware.facter.reportPath = ./facter.json;
  ironman.lidarr.enable = true;
  networking = {
    hostName = "lidarr";
    nameservers = [
      "192.168.248.2"
    ];
  };
}
