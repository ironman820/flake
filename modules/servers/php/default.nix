{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.servers.php;
in
{
  options.ironman.servers.php = with types; {
    enable = mkBoolOpt false "Enable or disable php support";
    extraConfig = mkOpt attrs { } "PHPFPM Config options";
    ini = mkOpt (listOf str) [ ] "PHP INI settings";
    mssql = mkBoolOpt false "Install the mssql extension";
  };

  config = mkIf cfg.enable {
    services.phpfpm = {
      pools.rcm = {
        phpOptions = strings.concatStringsSep "\n" config.ironman.servers.php.ini;
        phpPackage = pkgs.php74;
        settings = mkMerge [
          {
            pm = "dynamic";
            "listen.owner" = config.services.nginx.user;
            "pm.max_children" = 5;
            "pm.start_servers" = 2;
            "pm.min_spare_servers" = 1;
            "pm.max_spare_servers" = 3;
            "pm.max_requests" = 500;
          }
          (
            mkAliasDefinitions options.ironman.servers.php.extraConfig
          )
        ];
        user = config.services.nginx.user;
      };
    };
    environment.systemPackages = with pkgs; [
      php74
    ];
  };
}
