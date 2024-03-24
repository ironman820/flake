{
  config,
  lib,
  options,
  ...
}: let
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf;
  inherit (lib.mine) mkOpt;
  inherit (lib.types) attrs;
  cfg = config.mine.servers.caddy;
in {
  options.mine.servers.caddy = {
    enable = mkEnableOption "Enable Caddy";
    virtualHosts = mkOpt attrs {} "List of virtual host settings";
  };

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      # logDir = "/data/caddy/log";
      virtualHosts = mkAliasDefinitions options.mine.servers.caddy.virtualHosts;
    };
  };
}
