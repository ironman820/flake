{ config, lib, options, ... }:
let
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf;
  inherit (lib.ironman) mkOpt;
  inherit (lib.types) str;
  cfg = config.ironman.servers.lighttpd;
in
{
  options.ironman.servers.lighttpd = {
    enable = mkEnableOption "Enable or disable tftp support";
    root = mkOpt str "" "HTTP Document Root";
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf config.ironman.networking.firewall {
      allowedTCPPorts = [
        80
      ];
    };
    services.lighttpd = {
      enable = true;
      document-root = mkAliasDefinitions options.ironman.servers.lighttpd.root;
    };
  };
}
