{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.wireless-profiles;
in {
  options.ironman.wireless-profiles = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
    home = mkBoolOpt true "Load the home profiles";
  };

  config = mkIf cfg.enable {
    ironman.root-sops.secrets = mkMerge [
      (mkIf config.ironman.wireless-profiles.home {
        da_psk = {
          format = "binary";
          mode = "0400";
          path = "/etc/NetworkManager/system-connections/DumbledoresArmy.nmconnection";
          sopsFile = ./secrets/da.wifi;
        };
      })
    ];
  };
}
