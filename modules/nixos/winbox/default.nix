{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.winbox;
in
{
  options.ironman.winbox = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf config.ironman.networking.firewall {
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
