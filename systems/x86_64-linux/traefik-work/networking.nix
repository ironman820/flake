_: {
  mine.networking.basic = {
    gateway = "192.168.20.1";
    dhcp = false;
    interface = "ens18";
    address = "192.168.20.4";
    prefix = 24;
    nameservers = [
      "192.168.20.2"
    ];
  };
}
