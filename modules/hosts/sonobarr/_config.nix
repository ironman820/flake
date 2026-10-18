{
  hardware.facter.reportPath = ./facter.json;
  ironman.sonobarr.enable = true;
  networking = {
    hostName = "sonobarr";
    nameservers = [
      "192.168.248.2"
    ];
  };
}
