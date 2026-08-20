{
  config,
  inputs,
  lib,
  self,
  ...
}:
{
  imports =
    with inputs;
    [
      ./hardware.nix
      microvm.nixosModules.host
    ]
    ++ (with self.nixosModules; [
      # pdns-work
      # rcm-work
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
  microvm = {
    autostart = [
      # "pdns-work"
      # "rcm-work"
    ];
    host.enable = true;
  };
  networking = {
    firewall.enable = false;
    hostName = "pve-work";
    useNetworkd = true;
  };
  nix = {
    optimise.automatic = lib.mkForce false;
    settings = {
      auto-optimise-store = lib.mkForce false;
      cores = 1;
    };
  };
  security.sudo.wheelNeedsPassword = false;
  services = {
    openssh.settings.PermitRootLogin = "no";
  };
  sops.keepGenerations  = 0;
  systemd.network = {
    enable = true;
    netdevs."br0".netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
    networks = {
      "10-lan" = {
        matchConfig.Name = [
          "enp*"
          "vm-*"
        ];
        networkConfig.Bridge = "br0";
      };
      "10-lan-bridge" = {
        linkConfig.RequiredForOnline = "routable";
        matchConfig.Name = "br0";
        networkConfig = {
          Address = [
            "192.168.20.10/23"
          ];
          Gateway = [ "192.168.20.1" ];
          DNS = [
            "208.80.144.50"
            "208.80.144.51"
          ];
        };
      };
    };
  };
  # topology = {
  #   nodes = {
  #     pdns-work = {
  #     name = "pdns.work";
  #     deviceType = "nixos";
  #     guestType = "microvm";
  #     interfaces.vm-pdns-work = {
  #       addresses = [
  #         "192.168.20.2"
  #       ];
  #       network = "work";
  #       physicalConnections = [
  #         (config.lib.topology.mkConnection "pve-work" "br0")
  #       ];
  #       virtual = true;
  #     };
  #     parent = "pve-work";
  #     services = {
  #       dns = {
  #         details.technitium.text = "Technitium DNS Server";
  #         icon = "services.technitium";
  #         info = "https://pdns.desk.niceastman.com/";
  #         name = "Work DNS Server";
  #       };
  #       ntp = {
  #         details.ntp.text = "NTP server";
  #         icon = "services.ntpd-rs";
  #         name = "Home NTP Server";
  #       };
  #     };
  #   };
  #     rcm-work = {
  #       name = "rcm.work";
  #       deviceType = "nixos";
  #       guestType = "microvm";
  #       interfaces.vm-rcm-work = {
  #         addresses = [
  #           "192.168.20.101"
  #         ];
  #         network = "work";
  #         physicalConnections = [
  #           (config.lib.topology.mkConnection "pve-work" "br0")
  #         ];
  #       };
  #       parent = "pve-work";
  #       services = {
  #         nginx = {
  #           details.rcm.text = "RCM Development Server";
  #           icon = "services.nginx";
  #           info = "https://rcm.desk.niceastman.com/";
  #         };
  #       };
  #     };
  #   };
  #   self = {
  #     hardware = {
  #       info = "Dell Mini";
  #     };
  #     name = "pve.desk";
  #     interfaces = {
  #       br0 = { };
  #       enp0s31f6 = {
  #         network = "work";
  #         sharesNetworkWith = [
  #           (br0: true)
  #         ];
  #       };
  #     };
  #   };
  # };
}
