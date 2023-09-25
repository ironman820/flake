{ config, inputs, lib, options, pkgs, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.servers.dns.recursor;
in
{
  options.ironman.servers.dns.recursor = with types; {
    enable = mkBoolOpt false "Enable or disable tftp support";
    forwards = mkOpt str "" "Forward Zone Definitions";
    lua = mkOpt (listOf str) [ ] "LUA Configuration file override";
  };

  config = mkIf cfg.enable {
    services.pdns-recursor = {
      dns.allowFrom = [
        "10.0.0.0/8"
        "127.0.0.0/8"
        "172.16.0.0/12"
        "192.168.0.0/16"
      ];
      enable = true;
      forwardZones = mkAliasDefinitions options.ironman.servers.dns.recursor.forwards;
      luaConfig = strings.concatStringsSep "\n" config.ironman.servers.dns.recursor.lua;
    };
  };
}
