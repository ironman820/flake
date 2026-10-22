{
  boot.kernel.sysctl = {
    "vm.max_map_count" = 524288;
    "fs.file-max" = 131072;
  };
  hardware.facter.reportPath = ./facter.json;
  ironman.sonarqube.enable = true;
  networking = {
    hostName = "sonarqube";
    nameservers = [
      "192.168.248.2"
    ];
  };
}
