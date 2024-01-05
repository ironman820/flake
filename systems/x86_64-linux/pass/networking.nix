{ config, ... }:
{
  royell.networking = {
    gateway = "172.16.0.1";
    dhcp = false;
    interface = "ens18";
    address = "172.16.0.16";
    prefix = 24;
    nameservers = [
      "172.16.0.3"
      "172.16.0.4"
    ];
  };
}
