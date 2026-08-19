{
  config,
  flakeRoot,
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
      # pdns-home
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
      # "pdns-home"
    ];
    host.enable = true;
  };
  networking = {
    firewall.enable = false;
    hostName = "pve";
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
          "enp0s31f6"
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
            # "192.168.248.2"
            "192.168.0.10"
          ];
        };
      };
    };
  };
  topology = {
    # nodes.pdns-home = {
    #   name = "pdns.home";
    #   deviceType = "nixos";
    #   guestType = "microvm";
    #   interfaces.vm-pdns = {
    #     addresses = [
    #       "192.168.248.2"
    #     ];
    #     network = "home";
    #     physicalConnections = [
    #       (config.lib.topology.mkConnection "pve2" "br0")
    #     ];
    #     virtual = true;
    #   };
    #   parent = "pve2";
    #   services = {
    #     dns = {
    #       details.technitium.text = "Technitium DNS Server";
    #       icon = "services.technitium";
    #       info = "https://pdns.home.niceastman.com/";
    #       name = "Home DNS Server";
    #     };
    #     ntp = {
    #       details.ntp.text = "NTP server";
    #       icon = "services.ntpd-rs";
    #       name = "Home NTP Server";
    #     };
    #   };
    # };
    self = {
      hardware = {
        info = "Dell Mini";
      };
      name = "pve.desk";
      interfaces = {
        enp0s31f6 = {
          network = "work";
          sharesNetworkWith = [
            (br0: true)
          ];
        };
      };
    };
  };
}
