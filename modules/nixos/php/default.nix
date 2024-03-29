{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  inherit (lib) mkAliasDefinitions mkIf mkMerge;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.types) attrs listOf str;
  cfg = config.mine.servers.php;
in {
  options.mine.servers.php = {
    enable = mkBoolOpt false "Enable or disable php support";
    extraConfig = mkOpt attrs {} "PHPFPM Config options";
    ini = mkOpt (listOf str) [] "PHP INI settings";
    mssql = mkBoolOpt false "Install the mssql extension";
  };

  config = mkIf cfg.enable {
    services.phpfpm = {
      pools.rcm = {
        inherit (config.services.nginx) user;
        phpOptions = concatStringsSep "\n" config.mine.servers.php.ini;
        phpPackage = pkgs.php;
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
          (mkAliasDefinitions options.mine.servers.php.extraConfig)
        ];
      };
    };
    environment.systemPackages = with pkgs; [php psalm];
  };
}
