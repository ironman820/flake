{ config, ... }:
{
  networking = {
    defaultGateway.address = "192.168.20.1";
    dhcpcd.enable = false;
    interfaces.ens18.ipv4.addresses = [{
      address = "192.168.20.2";
      prefixLength = 24;
    }];
    nameservers = [
      "192.168.0.10"
      "208.80.144.50"
      "208.80.144.51"
    ];
  };
}
