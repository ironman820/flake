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
      pdns-home
      systemdboot
      ups
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
      "pdns-home"
    ];
    host.enable = true;
  };
  networking = {
    hostName = "pve2";
    useNetworkd = true;
  };
  nix = {
    optimise.automatic = lib.mkForce false;
    settings = {
      auto-optimise-store = lib.mkForce false;
      cores = 1;
    };
  };
  power.ups = {
    ups.ups = {
      description = "Cyberpower 1500VA";
      directives = [
        "vendorid = 0764"
        "productid = 0501"
        "serial = QBSQN7002026"
      ];
      driver = "usbhid-ups";
      port = "auto";
    };
    upsmon.monitor.ups = {
      system = "ups@localhost";
      type = "master";
      user = "upsadmin";
    };
    users.upsadmin = {
      actions = [
        "SET"
      ];
      instcmds = [
        "ALL"
      ];
      passwordFile = config.sops.secrets.ups_password.path;
      upsmon = "primary";
    };
  };
  security.sudo.wheelNeedsPassword = false;
  services = {
    # openssh.settings.PermitRootLogin = "no";
  };
  sops.secrets.ups_password = {
    sopsFile = "${flakeRoot}/.secrets/ups.yaml";
    group = config.power.ups.upsmon.group;
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
          Gateway = [ "192.168.248.1" ];
          DNS = [
            "192.168.248.2"
          ];
        };
      };
    };
  };
  topology = {
    nodes.pdns-home = {
      name = "pdns.home";
      deviceType = "nixos";
      guestType = "microvm";
      interfaces.vm-pdns = {
        addresses = [
          "192.168.248.2"
        ];
        network = "home";
        physicalConnections = [
          (config.lib.topology.mkConnection "pve2" "br0")
        ];
        virtual = true;
      };
      parent = "pve2";
      services = {
        dns = {
          details.technitium.text = "Technitium DNS Server";
          icon = "services.technitium";
          info = "https://pdns.home.niceastman.com/";
          name = "Home DNS Server";
        };
        ntp = {
          details.ntp.text = "NTP server";
          icon = "services.ntpd-rs";
          name = "Home NTP Server";
        };
      };
    };
    self = {
      name = "pve2.home";
      interfaces = {
        enp1s0 = {
          network = "home";
          sharesNetworkWith = [
            (br0: true)
          ];
        };
      };
    };
  };
}
