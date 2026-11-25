{ self, ... }: {
  flake.nixosModules.mybooksConfig =
    { config, ... }:
    let
      cfg = srv.mybooks;
      srv = config.ironman.servers;
    in
    {
      hardware.facter.reportPath = ./facter.json;
      ironman = {
        bookorbit.environmentFile = config.sops.secrets.bookorbit_env.path;
        smbShares.fs."/data".server = srv.storage.ip;
        staticIP.address = cfg.ip;
      };
      networking = {
        inherit (cfg) hostName;
      };
      sops.secrets.bookorbit_env =
        let
          inherit (config.ironman.user) name;
        in
        {
          sopsFile = "${self.outPath}/.secrets/mybooks.yaml";
          owner = name;
          group = name;
        };
    };
}
