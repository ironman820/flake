{ config, ... }:
{
  mine.networking = {
    gateway = "192.168.20.1";
    dhcp = false;
    interface = "ens18";
    address = "192.168.20.7";
    prefix = 24;
    nameservers = [
      "192.168.20.2"
    ];
    network = "192.168.20.0";
  };
}
