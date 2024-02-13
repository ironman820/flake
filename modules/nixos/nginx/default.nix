{
  config,
  lib,
  options,
  ...
}: let
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf;
  inherit (lib.mine) mkOpt;
  inherit (lib.types) attrs;
  cfg = config.mine.servers.nginx;
in {
  options.mine.servers.nginx = {
    enable = mkEnableOption "Enable or disable tftp support";
    virtualHosts = mkOpt attrs {} "List of virtual host settings";
  };

  config = mkIf cfg.enable {
    mine.user.extraGroups = [
      config.services.nginx.group
    ];
    services.nginx = {
      enable = true;
      virtualHosts = mkAliasDefinitions options.mine.servers.nginx.virtualHosts;
    };
  };
}
