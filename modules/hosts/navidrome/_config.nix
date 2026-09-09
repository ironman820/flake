{
  hardware.facter.reportPath = ./facter.json;
  ironman.navidrome.enable = true;
  networking = {
    hostName = "navidrome";
    nameservers = [
      "192.168.248.2"
    ];
  };
}
