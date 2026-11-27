{ config, ... }:
let
  cfg = srv.kcc;
  srv = config.ironman.servers;
in
{
  hardware.facter.reportPath = ./facter.json;
  ironman = {
    staticIP.address = cfg.ip;
  };
  networking = {
    inherit (cfg) hostName;
  };
}
