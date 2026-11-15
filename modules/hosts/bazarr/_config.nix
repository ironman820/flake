{
  hardware.facter.reportPath = ./facter.json;
  ironman.bazarr.enable = true;
  networking = {
    hostName = "bazarr";
    nameservers = [
      "192.168.248.2"
    ];
  };
}
