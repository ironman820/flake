{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.caddy;
in
{
  options.ironman.caddy = with types; {
    enable = mkEnableOption "Enable Caddy";
    virtualHosts = mkOptions {
      default = { };
      description = "List of virtual host settings";
      type = attrsOf (eitherOf str (listOf str));
    };
  };

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      logDir = "/data/caddy/log";
      virtualHosts = mkAliasDefinitions options.ironman.servers.caddy.virtualHosts;
    };
  };
}
