{
  inputs,
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
  ])
  ++ (with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-pc-ssd
  ]);
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  microvm.host.enable = true;
  networking = {
    hostName = "pve2";
    useNetworkd = true;
  };
  nix.settings.cores = 1;
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
        matchConfig.Name = [
          "enp1s0"
          "vm-*"
        ];
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
