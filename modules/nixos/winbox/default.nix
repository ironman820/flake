{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.winbox;
  fw = config.ironman.networking.firewall;
in
{
  options.ironman.winbox = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf fw {
      allowedTCPPorts = [
        8291
      ];
      allowedUDPPorts = [
        5678
        20561
      ];
    };
  };
}
