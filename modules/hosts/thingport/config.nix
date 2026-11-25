{ self, ... }: {
  flake.nixosModules.thingportConfig =
    { config, pkgs, ... }:
    let
      cfg = config.ironman.servers.thingport;
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
        staticIP.address = cfg.ip;
        thingport = {
          envFile = config.sops.secrets.thingport_env.path;
          flaresolverrIP = "192.168.248.119";
        };
      };
      networking = {
        inherit (cfg) hostName;
      };
      sops.secrets =
        let
          sopsFile = "${self.outPath}/.secrets/thingport.yaml";
          owner = config.ironman.user.name;
          group = config.ironman.user.name;
        in
        {
          thingport_env = {
            inherit sopsFile owner group;
          };
        };
    };
}
