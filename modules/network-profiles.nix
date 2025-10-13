{
  flake.nixosModules.network-profiles =
    {
      config,
      flakeRoot,
      lib,
      ...
    }:
    let
      inherit (lib) mkIf mkMerge mkOption;
      inherit (lib.types) bool;
      cfg = config.ironman.network-profiles;
      sopsFile = flakeRoot + "/.secrets/network-profiles.yaml";
      settingsPath = "/etc/NetworkManager/system-connections";
    in
    {
      options.ironman.network-profiles = {
        home = mkOption {
          type = bool;
          default = true;
          description = "Load the home profiles";
        };
        work = mkOption {
          type = bool;
          default = false;
          description = "Load Work profiles";
        };
      };

      config = {
        sops.secrets = mkMerge [
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
    };
}
