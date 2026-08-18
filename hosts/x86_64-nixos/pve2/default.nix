{
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
  ]
  ++ (with self.nixosModules; [
    systemdboot
    x64-linux
  ]);
  boot.tmp.cleanOnBoot = true;
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  microvm.host.enable = true;
  networking = {
    hostName = "pve2";
    useNetworkd = true;
  };
  nix.settings.cores = 1;
  preservation = {
    enable = true;
    preserveAt."/persist" = {
      directories = [
        "/tmp"
        "/var/lib/systemd/timers"
        "/var/lib/nixos"
        "/var/log"
      ];
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
        "/etc/nixos/keys.txt"
      ];
      users.ironman = {
        files = [
          ".config/sops/age/keys.txt"
        ];
      };
    };
  };
  security.sudo.wheelNeedsPassword = false;
  services = {
    # openssh.settings.PermitRootLogin = "no";
  };
  systemd.network = {
    enable = true;
    netdevs."br0".netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
    networks = {
      "10-lan" = {
        matchConfig.Name = ["enp1s0" "vm-*"];
        networkConfig.Bridge = "br0";
      };
      "10-lan-bridge" = {
        linkConfig.RequiredForOnline = "routable";
        matchConfig.Name = "br0";
        networkConfig = {
          Address = [
            "192.168.248.12/23"
          ];
          Gateway = "192.168.248.1";
          DNS = [
            "192.168.248.2"
          ];
        };
      };
    };
  };
  topology.self = {
    name = "PVE2";
    interfaces = {
      enp1s0 = {
        network = "home";
        sharesNetworkWith = [
          (br0: true)
        ];
      };
    };
  };
}
