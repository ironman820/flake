{ config, inputs, lib, options, pkgs, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.servers.caddy;
in
{
  options.ironman.servers.caddy = with types; {
    enable = mkBoolOpt false "Enable Caddy";
    virtualHosts = mkOpt attrs { } "List of virtual host settings";
  };

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      # logDir = "/data/caddy/log";
      virtualHosts = mkAliasDefinitions options.ironman.servers.caddy.virtualHosts;
    };
  };
}
