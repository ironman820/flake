{ self, ... }: {
  flake.nixosModules.libraryConfig = { config, pkgs, ... }: {
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
    ironman.bookorbit = {
      enable = true;
      environmentFile = config.sops.secrets.bookorbit_env.path;
    };
    networking = {
      defaultGateway = "192.168.248.1";
      dhcpcd.enable = false;
      hostName = "library";
      interfaces.ens18.ipv4.addresses = [
        {
          address = "192.168.248.101";
          prefixLength = 23;
        }
      ];
      nameservers = [
        "192.168.248.2"
      ];
      useDHCP = false;
    };
    sops.secrets.bookorbit_env =
      let
        inherit (config.ironman.user) name;
      in
      {
        sopsFile = "${self.outPath}/.secrets/library.yaml";
        owner = name;
        group = name;
      };
  };
}
