{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.servers.nginx;
  php = config.ironman.servers.php;
in
{
  options.ironman.servers.nginx = with types; {
    enable = mkEnableOption "Enable or disable tftp support";
    virtualHosts = mkOption {
      default = { };
      description = "List of virtual host settings";
      type = attrsOf (either str (listOf str));
    };
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
