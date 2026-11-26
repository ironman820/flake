{ config, ... }:
let
  cfg = srv.bazarr;
  srv = config.ironman.servers;
in
{
  hardware.facter.reportPath = ./facter.json;
  ironman = {
    smbShares.fs."/data".server = srv.storage.ip;
    staticIP.address = cfg.ip;
  };
  networking = {
    inherit (cfg) hostName;
  };
}
