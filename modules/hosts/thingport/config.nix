{ self, ... }: {
  flake.nixosModules.thingportConfig = { config, pkgs, ... }: {
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
    ironman.thingport = {
      enable = true;
      envFile = config.sops.secrets.thingport_env.path;
      flaresolverrIP = "192.168.248.119";
    };
    networking = {
      defaultGateway = "192.168.248.1";
      dhcpcd.enable = false;
      hostName = "thingport";
      interfaces.ens18.ipv4.addresses = [
        {
          address = "192.168.248.127";
          prefixLength = 23;
        }
      ];
      nameservers = [
        "192.168.248.2"
      ];
      useDHCP = false;
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
