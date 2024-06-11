{
  config,
  lib,
  options,
  ...
}: let
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf;
  inherit (lib.mine) mkOpt;
  inherit (lib.types) str;
  cfg = config.mine.servers.nfs;
in {
  options.mine.servers.nfs = {
    enable = mkEnableOption "Enable or disable tftp support";
    exports = mkOpt str "" "NFS Export Definitions";
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf config.mine.networking.basic.firewall {
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
      inherit (cfg) enable;
      exports = mkAliasDefinitions options.mine.servers.nfs.exports;
      mountdPort = 4002;
    };
  };
}
