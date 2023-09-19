{ config, inputs, lib, options, pkgs, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.servers.lighttpd;
in
{
  options.ironman.servers.lighttpd = with types; {
    enable = mkBoolOpt false "Enable or disable tftp support";
    root = mkOpt str "" "HTTP Document Root";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
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
