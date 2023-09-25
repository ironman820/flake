{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf;
  inherit (lib.ironman) mkOpt;
  inherit (lib.types) attrs;
  cfg = config.ironman.servers.caddy;
in
{
  options.ironman.servers.caddy = {
    enable = mkEnableOption "Enable Caddy";
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
