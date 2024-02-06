{
  config,
  lib,
  options,
  ...
}: let
  inherit (lib) mkAliasDefinitions mkEnableOption mkIf;
  inherit (lib.mine) mkOpt;
  inherit (lib.types) str;
  cfg = config.mine.servers.lighttpd;
in {
  options.mine.servers.lighttpd = {
    enable = mkEnableOption "Enable or disable tftp support";
    root = mkOpt str "" "HTTP Document Root";
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf config.mine.networking.firewall {
      allowedTCPPorts = [
        80
      ];
    };
    services.lighttpd = {
      enable = true;
      document-root = mkAliasDefinitions options.mine.servers.lighttpd.root;
    };
  };
}
