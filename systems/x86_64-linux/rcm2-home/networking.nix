{ config, ... }:
{
  ironman.networking = {
    gateway = "192.168.254.1";
    dhcp = false;
    interface = "ens18";
    address = "192.168.254.11";
    prefix = 24;
    nameservers = [
      "192.168.254.2"
    ];
  };
}
