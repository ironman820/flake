{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.networking.profiles;
  sopsFile = ./secrets/profiles.yaml;
in {
  options.mine.networking.profiles = {
    enable = mkEnableOption "Enable the default settings?";
    home = mkBoolOpt true "Load the home profiles";
    work = mkBoolOpt false "Load Work profiles";
  };

  config = mkIf cfg.enable {
    mine.sops.secrets = mkMerge [
      (mkIf cfg.home {
        da_psk = {
          inherit sopsFile;
          mode = "0400";
          path = "/etc/NetworkManager/system-connections/DumbledoresArmy.nmconnection";
        };
      })
      (mkIf cfg.work {
        office_psk = {
          inherit sopsFile;
          mode = "0400";
          path = "/etc/NetworkManager/system-connections/office.nmconnection";
        };
        royell_vpn = {
          inherit sopsFile;
          mode = "0400";
          path = "/etc/NetworkManager/system-connections/Royell.nmconnection";
        };
      })
    ];
  };
}
