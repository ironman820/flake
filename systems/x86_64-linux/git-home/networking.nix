{ config, ... }:
{
  ironman.networking = {
    gateway = "192.168.254.1";
    dhcp = false;
    interface = "ens18";
    address = "192.168.254.9";
    prefix = 24;
    nameservers = [
      "208.80.144.50"
      "208.80.144.51"
    ];
  };
}
