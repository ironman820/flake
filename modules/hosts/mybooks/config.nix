{ self, ... }: {
  flake.nixosModules.mybooksConfig =
    { config, pkgs, ... }:
    let
      cfg = config.ironman.servers.mybooks;
    in
    {
      environment.systemPackages = [
        pkgs.cifs-utils
      ];
      fileSystems."/data" = {
        device = "//192.168.248.100/data";
        fsType = "cifs";
        options =
          let
            automount_opts = "x-systemd.automount,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
          in
          [
            "${automount_opts},uid=1000,gid=1000"
          ];
      };
      hardware.facter.reportPath = ./facter.json;
      ironman = {
        bookorbit.environmentFile = config.sops.secrets.bookorbit_env.path;
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
