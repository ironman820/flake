{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.winbox;
in
{
  options.ironman.winbox = with types; {
    enable = mkBoolOpt (config.ironman.gnome.enable) "Enable the default settings?";
  };

  config = mkIf (cfg.enable && config.ironman.gnome.enable) {
    networking.firewall = {
      allowedTCPPorts = [
        8291
      ];
      allowedUDPPorts = [
        20561
      ];
    };
  };
}
