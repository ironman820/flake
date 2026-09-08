{
  hardware.facter.reportPath = ./facter.json;
  networking = {
    hostName = "flaresolverr";
    nameservers = [
      "192.168.248.2"
    ];
  };
  services.flaresolverr.enable = true;
}
