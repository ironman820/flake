{ config, ... }:
let
  cfg = config.ironman.servers.spoolman;
in
{
  hardware.facter.reportPath = ./facter.json;
  ironman = {
    spoolman.corsOrigin = "https://${cfg.service.name}.niceastman.com";
    staticIP.address = cfg.ip;
  };
  networking = {
    inherit (cfg) hostName;
  };
}
