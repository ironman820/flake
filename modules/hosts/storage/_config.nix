{
  hardware.facter.reportPath = ./facter.json;
  networking = {
    hostName = "storage";
    nameservers = [
      "192.168.248.2"
    ];
  };
}
