{ config, ... }:
{
  networking = {
    defaultGateway.address = "192.168.254.1";
    dhcpcd.enable = false;
    interfaces.enp1s0.ipv4.addresses = [{
      address = "192.168.254.9";
      prefixLength = 24;
    }];
    nameservers = [
      "208.80.144.50"
      "208.80.144.51"
    ];
  };
}
