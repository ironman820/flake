{ config, lib, options, pkgs, ... }:
let
  inherit (config.ironman.servers) php;
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf mkMerge;
  inherit (lib.ironman) mkOpt;
  inherit (lib.types) attrs;
  cfg = config.ironman.servers.httpd;
in
{
  options.ironman.servers.httpd = {
    enable = mkEnableOption "Enable or disable tftp support";
    virtualHosts = mkOpt attrs { } "List of virtual host settings";
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf config.ironman.networking.firewall {
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
