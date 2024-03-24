{ config, lib, options, pkgs, ... }:
let
  inherit (config.mine.servers) php;
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf mkMerge;
  inherit (lib.mine) mkOpt;
  inherit (lib.types) attrs;
  cfg = config.mine.servers.httpd;
in
{
  options.mine.servers.httpd = {
    enable = mkEnableOption "Enable or disable tftp support";
    virtualHosts = mkOpt attrs { } "List of virtual host settings";
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf config.mine.networking.basic.firewall {
      allowedTCPPorts = [
        80
      ];
    };
    services.httpd = mkMerge [
      {
        adminAddr = config.mine.user.email;
        enable = true;
        virtualHosts = mkAliasDefinitions options.mine.servers.httpd.virtualHosts;
      }
      (mkIf php.enable {
        enablePHP = true;
        phpPackage = pkgs.php74;
      })
    ];
  };
}
