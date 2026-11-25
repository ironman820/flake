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
  programs.MusicSyncConverter = {
    enable = true;
    service = {
      enable = true;
      sourceFolder = "/data/music";
      destinationFolder = "/data/player-sync";
      makeMp3 = true;
      mp3Bitrate = 320;
    };
  };
}
