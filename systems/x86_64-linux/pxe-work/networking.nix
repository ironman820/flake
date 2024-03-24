{ config, ... }:
{
  mine.networking.basic = {
    address = "192.168.20.3";
    dhcp = false;
    gateway = "192.168.20.1";
    interface = "ens18";
    nameservers = [
      "192.168.20.2"
    ];
    prefix = 24;
  };
}
