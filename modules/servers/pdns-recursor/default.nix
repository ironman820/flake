{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.servers.dns.recursor;
in
{
  options.ironman.servers.dns.recursor = with types; {
    enable = mkBoolOpt false "Enable or disable tftp support";
    forwards = mkOpt str "" "Forward Zone Definitions";
  };

  config = mkIf cfg.enable {
    services.pdns-recursor = {
      dns.allowFrom = [
        "127.0.0.0/8"
        "192.168.0.0/16"
      ];
      enable = true;
      forwardZones = mkAliasDefinitions options.ironman.servers.dns.recursor.forwards;
    };
  };
}
