{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.servers.dns.recursor;
in
{
  options.ironman.servers.dns.recursor = with types; {
    enable = mkEnableOption "Enable or disable tftp support";
    forwards = mkOption {
      default = "";
      description = "Forward Zone Definitions";
      type = str;
    };
    lua = mkOption {
      default = [ ];
      description = "LUA Configuration file override";
      type = (listOf str);
    };
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
