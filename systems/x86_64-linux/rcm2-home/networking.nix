_: {
  mine.networking.basic = {
    gateway = "192.168.253.1";
    dhcp = false;
    interface = "ens18";
    address = "192.168.253.6";
    prefix = 24;
    nameservers = [ "192.168.254.2" ];
  };
}
