{ config, inputs, lib, options, pkgs, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.servers.nginx;
  php = config.ironman.servers.php;
in
{
  options.ironman.servers.nginx = with types; {
    enable = mkBoolOpt false "Enable or disable tftp support";
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
