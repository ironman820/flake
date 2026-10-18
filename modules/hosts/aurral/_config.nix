{
  hardware.facter.reportPath = ./facter.json;
  ironman.aurral.enable = true;
  networking = {
    hostName = "aurral";
    nameservers = [
      "192.168.248.2"
    ];
  };
}
