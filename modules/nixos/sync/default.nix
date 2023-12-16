{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) mkBoolOpt;
  cfg = config.ironman.sync;
in {
  options.ironman.sync = {
    enable = mkEnableOption "Enable the default settings?";
    root = mkBoolOpt false "Whether to install the daemon as root";
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf config.ironman.networking.firewall {
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
        inherit (config.ironman.user) group;
        dataDir = "/home/${config.ironman.user.name}";
        enable = true;
        guiAddress = "0.0.0.0:8384";
        user = config.ironman.user.name;
      };
    };
  };
}
