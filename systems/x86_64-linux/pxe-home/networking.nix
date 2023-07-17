{ config, ... }:
{
  networking = {
    defaultGateway.address = "192.168.254.1";
    dhcpcd.enable = false;
    interfaces.ens18.ipv4.addresses = [{
      address = "192.168.254.8";
      prefixLength = 24;
    }];
    nameservers = [
      "208.80.144.50"
      "208.80.144.51"
    ];
  };
}
