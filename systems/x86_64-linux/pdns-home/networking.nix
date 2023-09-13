{ config, ... }:
{
  ironman.networking = {
    gateway = "192.168.254.1";
    dhcp = false;
    interface = "enp1s0";
    address = "192.168.254.2";
    prefix = 24;
    nameservers = [
      "208.80.144.50"
      "208.80.144.51"
    ];
  };
}
