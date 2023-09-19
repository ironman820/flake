{ config, inputs, lib, options, pkgs, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.servers.httpd;
  php = config.ironman.servers.php;
in
{
  options.ironman.servers.httpd = with types; {
    enable = mkBoolOpt false "Enable or disable tftp support";
    virtualHosts = mkOpt attrs { } "List of virtual host settings";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [
        80
      ];
    };
    services.httpd = mkMerge [
      {
        adminAddr = config.ironman.user.email;
        enable = true;
        virtualHosts = mkAliasDefinitions options.ironman.servers.httpd.virtualHosts;
      }
      (mkIf php.enable {
        enablePHP = true;
        phpPackage = pkgs.php74;
      })
    ];
  };
}
