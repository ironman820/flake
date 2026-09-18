{ pkgs, ... }: {
  hardware.facter.reportPath = ./facter.json;
  ironman.guacamole =
    {
    enable = true;
    # userMappingXml = userMapping;
  };
  networking = {
    hostName = "rdp-work";
    nameservers = [
      "208.80.144.50"
      "208.80.144.51"
    ];
  };
}
