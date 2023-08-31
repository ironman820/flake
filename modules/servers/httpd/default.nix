{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.servers.httpd;
  php = config.ironman.servers.php;
in
{
  options.ironman.servers.httpd = with types; {
    enable = mkEnableOption "Enable or disable tftp support";
    virtualHosts = mkOption {
      default = { };
      description = "List of virtual host settings";
      type = attrsOf (either str (listOf str));
    };
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
