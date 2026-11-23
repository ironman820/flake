{
  hardware.facter.reportPath = ./facter.json;
  networking = {
    defaultGateway = "192.168.248.1";
    dhcpcd.enable = false;
    hostName = "thingport";
    interfaces.ens18.ipv4.addresses = [
      {
        address = "192.168.248.127";
        prefixLength = 23;
      }
    ];
    nameservers = [
      "192.168.248.2"
    ];
    useDHCP = false;
  };
}
