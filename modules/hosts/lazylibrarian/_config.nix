{
  hardware.facter.reportPath = ./facter.json;
  ironman.lazylibrarian.enable = true;
  networking = {
    hostName = "library";
    nameservers = [
      "192.168.248.2"
    ];
  };
}
