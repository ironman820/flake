{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.networking.profiles;
  sopsFile = ./secrets/profiles.yaml;
  settingsPath = "/etc/NetworkManager/system-connections";
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
          path = "${settingsPath}/DumbledoresArmy.nmconnection";
        };
        ironman_psk = {
          inherit sopsFile;
          mode = "0400";
          path = "${settingsPath}/Ironman.nmconnection";
        };
      })
      (mkIf cfg.work {
        d105_psk = {
          inherit sopsFile;
          mode = "0400";
          path = "${settingsPath}/105-desk.nmconnection";
        };
        office_psk = {
          inherit sopsFile;
          mode = "0400";
          path = "${settingsPath}/office.nmconnection";
        };
        royell_vpn = {
          inherit sopsFile;
          mode = "0400";
          path = "${settingsPath}/Royell.nmconnection";
        };
      })
    ];
  };
}
