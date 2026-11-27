{ config, ... }:
let
  cfg = config.ironman.servers.spoolman;
in
{
  hardware.facter.reportPath = ./facter.json;
  ironman = {
    smbShares.fs."/data".server = config.ironman.servers.storage.ip;
    spoolman = {
      corsOrigin = "https://${cfg.service.name}.niceastman.com,http://192.168.248.6";
      dataDir = "/data/docker/spoolman";
    };
    staticIP.address = cfg.ip;
  };
  networking = {
    inherit (cfg) hostName;
  };
}
