{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf;
  inherit (lib.ironman) mkOpt;
  inherit (lib.types) str;
  cfg = config.ironman.servers.nfs;
in
{
  options.ironman.servers.nfs = {
    enable = mkEnableOption "Enable or disable tftp support";
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
