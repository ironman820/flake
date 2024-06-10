{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.servers.sync;
in {
  options.mine.servers.sync = {
    enable = mkEnableOption "Enable the default settings?";
    root = mkBoolOpt false "Whether to install the daemon as root";
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf config.mine.networking.basic.firewall {
      allowedTCPPorts = [
        8384
        22000
      ];
      allowedUDPPorts = [
        21027
        22000
      ];
    };
    services = mkIf cfg.root {
      syncthing = {
        inherit (config.mine.user) group;
        dataDir = "/home/${config.mine.user.name}";
        enable = true;
        guiAddress = "0.0.0.0:8384";
        user = config.mine.user.name;
      };
    };
  };
}
