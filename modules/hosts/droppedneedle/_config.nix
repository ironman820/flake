{
  hardware.facter.reportPath = ./facter.json;
  ironman.droppedneedle.enable = true;
  networking = {
    hostName = "droppedneedle";
    nameservers = [
      "192.168.248.2"
    ];
  };
  virtualisation.oci-containers.containers."droppedneedle".volumes = [
    "/shares/data/docker/droppedneedle/cache:/app/cache:rw"
    "/shares/data/docker/droppedneedle/config:/app/config:rw"
    "/shares/data/downloads/music:/slskd-downloads:rw"
    "/shares/data/music:/music:rw"
  ];
}
