{ config, ... }:
{
  ironman.networking = {
    gateway = "192.168.20.1";
    dhcp = false;
    interface = "ens18";
    address = "192.168.20.2";
    prefix = 24;
    nameservers = [
      "192.168.0.10"
      "208.80.144.50"
      "208.80.144.51"
    ];
  };
}
