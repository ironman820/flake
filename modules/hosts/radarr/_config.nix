{
  hardware.facter.reportPath = ./facter.json;
  ironman.radarr.enable = true;
  networking = {
    hostName = "radarr";
    nameservers = [
      "192.168.248.2"
    ];
  };
}
