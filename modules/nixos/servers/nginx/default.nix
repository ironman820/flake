{ config, inputs, lib, options, pkgs, ... }:
let
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf;
  inherit (lib.ironman) mkOpt;
  inherit (lib.types) attrs;
  cfg = config.ironman.servers.nginx;
  php = config.ironman.servers.php;
in
{
  options.ironman.servers.nginx = {
    enable = mkEnableOption "Enable or disable tftp support";
    virtualHosts = mkOpt attrs { } "List of virtual host settings";
  };

  config = mkIf cfg.enable {
    ironman.user.extraGroups = [
      config.services.nginx.group
    ];
    services.nginx = {
      enable = true;
      virtualHosts = mkAliasDefinitions options.ironman.servers.nginx.virtualHosts;
    };
  };
}
