{ config, inputs, lib, options, pkgs, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.servers.nfs;
in
{
  options.ironman.servers.nfs = with types; {
    enable = mkBoolOpt false "Enable or disable tftp support";
    exports = mkOpt str "" "NFS Export Definitions";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [
        111
        2049
        4002
      ];
      allowedUDPPorts = [
        111
        2049
        4002
      ];
    };
    services.nfs.server = {
      enable = true;
      exports = mkAliasDefinitions options.ironman.servers.nfs.exports;
      mountdPort = 4002;
    };
  };
}