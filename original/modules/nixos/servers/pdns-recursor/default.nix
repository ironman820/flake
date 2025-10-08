{
  config,
  lib,
  options,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkAliasDefinitions strings;
  inherit (lib.mine) mkOpt;
  inherit (lib.types) str listOf;
  cfg = config.mine.servers.dns.recursor;
in {
  options.mine.servers.dns.recursor = {
    enable = mkEnableOption "Enable or disable tftp support";
    forwards = mkOpt str "" "Forward Zone Definitions";
    lua = mkOpt (listOf str) [] "LUA Configuration file override";
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
      forwardZones = mkAliasDefinitions options.mine.servers.dns.recursor.forwards;
      luaConfig = strings.concatStringsSep "\n" config.mine.servers.dns.recursor.lua;
    };
  };
}
