{ config, ... }:
let
  srv = config.ironman.servers;
  cfg = srv.musicsync;
in
{
  hardware.facter.reportPath = ./facter.json;
  ironman = {
    smbShares.fs."/data".server = srv.storage.ip;
    staticIP.address = cfg.ip;
  };
  programs.smsync = {
    enable = true;
    service = {
      enable = true;
      sourceFolder = "/data/music";
      destinationFolder = "/data/player-sync";
    };
  };
}
