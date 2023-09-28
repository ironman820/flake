{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.sync;
in {
  options.ironman.sync = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
    root = mkBoolOpt false "Whether to install the daemon as root";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
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
        dataDir = "/home/${config.ironman.user.name}";
        enable = true;
        group = config.ironman.user.group;
        guiAddress = "0.0.0.0:8384";
        user = config.ironman.user.name;
      };
    };
  };
}