{ self, ... }: {
  flake.nixosModules.mymusicConfig =
    { config, ... }:
    let
      cfg = srv.mymusic;
      srv = config.ironman.servers;
      user = config.ironman.user.name;
    in
    {
      hardware.facter.reportPath = ./facter.json;
      ironman = {
        navidrome = {
          DataFolder = "/shares/data/docker/navidrome";
          environmentFile = config.sops.secrets.navidrome_env.path;
          MusicFolder = "/shares/data/music";
        };
        smbShares.fs."/shares".server = srv.storage.ip;
        staticIP.address = cfg.ip;
      };
      networking = {
        inherit (cfg) hostName;
      };
      sops.secrets.navidrome_env = {
        sopsFile = "${self.outPath}/.secrets/mymusic.yaml";
        owner = user;
        group = user;
      };
    };
}
