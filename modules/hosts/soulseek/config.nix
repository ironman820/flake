{ self, ... }: {
  flake.nixosModules.slskConfig =
    { config, ... }:
    let
      cfg = srv.slsk;
      srv = config.ironman.servers;
      dlFolder = "/data/downloads";
    in
    {
      hardware.facter.reportPath = ./facter.json;
      ironman = {
        smbShares.fs."/data".server = srv.storage.ip;
        staticIP.address = cfg.ip;
        slsk = {
          downloads = "${dlFolder}/music";
          environmentFile = config.sops.secrets.slskd_env.path;
          incomplete = "${dlFolder}/incomplete";
          shares = [
            "/data/music"
          ];
        };
      };
      networking = {
        inherit (cfg) hostName;
      };
      sops.secrets.slskd_env = {
        group = config.ironman.user.name;
        sopsFile = "${self.outPath}/.secrets/soulseek.yaml";
        owner = config.ironman.user.name;
      };
      topology =
        let
          inherit (config.lib.topology) mkConnection;
        in
        {
          id = "soulseek";
          self = {
            interfaces.ens18 = {
              network = "home";
              physicalConnections = [
                (mkConnection "pve" "vmbr0")
              ];
            };
            deviceType = "nixos";
            guestType = "nixos-container";
            name = "slsk";
            parent = "pve";
          };
        };
    };
}
