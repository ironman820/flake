{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.servers.lighttpd;
in
{
  options.ironman.servers.lighttpd = with types; {
    enable = mkOption {
      default = false;
      description = "Enable or disable tftp support";
      type = bool;
    };
    root = mkOption {
      default = "";
      description = "HTTP Document Root";
      type = str;
    };
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
