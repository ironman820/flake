{ config, ... }:
{
  mine.networking = {
    gateway = "192.168.20.1";
    dhcp = false;
    interface = "ens18";
    address = "192.168.20.6";
    prefix = 24;
    nameservers = [
      "192.168.20.2"
    ];
  };
}
