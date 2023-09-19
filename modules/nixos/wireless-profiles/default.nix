{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.wireless-profiles;
in {
  options.ironman.wireless-profiles = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
    home = mkBoolOpt true "Load the home profiles";
    work = mkBoolOpt false "Load Work profiles";
  };

  config = mkIf cfg.enable {
    ironman.sops.secrets = mkMerge [
      (mkIf cfg.home {
        da_psk = {
          format = "binary";
          mode = "0400";
          path = "/etc/NetworkManager/system-connections/DumbledoresArmy.nmconnection";
          sopsFile = ./secrets/da.wifi;
        };
      })
      (mkIf cfg.work {
        office_psk = {
          format = "binary";
          mode = "0400";
          path = "/etc/NetworkManager/system-connections/office.nmconnection";
          sopsFile = ./secrets/office.wifi;
        };
      })
    ];
  };
}
