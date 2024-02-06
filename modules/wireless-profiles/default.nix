{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.mine) mkBoolOpt;
  cfg = config.mine.wireless-profiles;
in {
  options.mine.wireless-profiles = {
    enable = mkEnableOption "Enable the default settings?";
    home = mkBoolOpt true "Load the home profiles";
    work = mkBoolOpt false "Load Work profiles";
  };

  config = mkIf cfg.enable {
    mine.sops.secrets = mkMerge [
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
