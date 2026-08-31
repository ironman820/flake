{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.topology = {
    imports = [
      inputs.nix-topology.nixosModules.default
    ];
  };
  perSystem =
    {
      lib,
      ...
    }:
    {
      topology.modules = [
        (
          { config, ... }:
          {
            icons = {
              devices = {
                mikrotik.file = ./mikrotik-white.svg;
                server.file = ./server.svg;
              };
              services = {
                calibreweb.file = ./calibreweb.svg;
                proxmox.file = ./proxmox.png;
                rcm.file = ./rcm.svg;
                technitium.file = ./technitium.png;
              };
            };
            nixosConfigurations = self.nixosConfigurations;
            networks = {
              home = {
                name = "Home Network";
                cidrv4 = "192.168.248.0/23";
              };
              work = {
                name = "Work Network";
                cidrv4 = "192.168.20.0/23";
              };
            };
            nodes =
              let
                inherit (config.lib.topology)
                  mkConnection
                  mkDevice
                  mkInternet
                  mkRouter
                  mkSwitch
                  ;
              in
              {
                ap = mkDevice "AP" {
                  hardware.image = ./wap-ax.png;
                  icon = "devices.mikrotik";
                  info = "MikroTik wAP ax";
                  interfaceGroups = [
                    [
                      "ether1"
                      "ether2"
                      "wifi1"
                      "wifi2"
                    ]
                  ];
                  interfaces.ether1 = {
                    addresses = [
                      "192.168.248.4"
                    ];
                    network = "home";
                    sharesNetworkWith = [
                      (lib.const true)
                    ];
                  };
                };
                internet = mkInternet {
                  connections = [
                    (mkConnection "router" "ether1")
                    (mkConnection "work-switch" "ether1")
                  ];
                };
                nas = mkDevice "NAS" {
                  hardware.image = ./ds918plus.png;
                  icon = "devices.cloud-server";
                  info = "Synology DS918+";
                  interfaceGroups = [
                    [
                      "ether1"
                      "ether2"
                    ]
                  ];
                  interfaces.lag1 = {
                    addresses = [
                      "192.168.248.13"
                    ];
                    network = "home";
                    sharesNetworkWith = [
                      (lib.const true)
                    ];
                    type = "bridge";
                    virtual = true;
                  };
                };
                pve = mkDevice "pve.home" {
                  icon = "devices.server";
                  info = "Custom Built Server";
                  interfaces = {
                    vmbr0 = {
                      addresses = [
                        "192.168.248.11"
                      ];
                      network = "home";
                      sharesNetworkWith = [
                        (lib.const true)
                      ];
                      type = "bridge";
                    };
                    enp42s0.type = "ethernet";
                  };
                  services.proxmox = {
                    icon = "services.proxmox";
                    info = "https://pve.home.niceastman.com";
                    name = "Home Server";
                  };
                };
                pve-work = mkDevice "pve.desk" {
                  icon = "devices.server";
                  info = "Dell Mini";
                  interfaces = {
                    vmbr0 = {
                      addresses = [
                        "192.168.20.10"
                      ];
                      network = "work";
                      sharesNetworkWith = [
                        (lib.const true)
                      ];
                      type = "bridge";
                    };
                    nic0.type = "ethernet";
                  };
                  services.proxmox = {
                    icon = "services.proxmox";
                    info = "https://pve.desk.niceastman.com";
                    name = "Work Server";
                  };
                };
                router = mkRouter "Router" {
                  connections = {
                    sfp-sfpplus1 = [
                      (mkConnection "switch" "sfp+1")
                      (mkConnection "switch" "sfp+2")
                    ];
                    wg0 = [
                      (mkConnection "work-router" "wg0")
                    ];
                  };
                  hardware.image = ./rb5009.png;
                  icon = "devices.mikrotik";
                  info = "MikroTik RB5009UG+S+";
                  interfaceGroups = [
                    [
                      "ether2"
                      "ether3"
                      "ether4"
                      "ether5"
                      "ether6"
                      "ether7"
                      "ether8"
                      "sfp-sfpplus1"
                    ]
                    [ "ether1" ]
                    [ "wg0" ]
                  ];
                  interfaces = {
                    sfp-sfpplus1 = {
                      addresses = [ "192.168.248.1" ];
                      network = "home";
                      type = "fiber-duplex";
                    };
                    wg0.type = "wireguard";
                  };
                };
                switch = mkSwitch "Switch" {
                  connections = {
                    ether1 = mkConnection "ap" "ether1";
                    ether2 = mkConnection "nas" "ether1";
                    ether3 = mkConnection "nas" "ether2";
                    # ether4 = [
                    #   (mkConnection "pve2" "enp1s0")
                    #   (mkConnection "pve2" "br0")
                    # ];
                    ether5 = [
                      (mkConnection "pve" "enp42s0")
                      (mkConnection "pve" "vmbr0")
                    ];
                    lag1 = mkConnection "nas" "lag1";
                  };
                  hardware.image = ./css318.png;
                  icon = "devices.mikrotik";
                  info = "MikroTik CSS318-16G-2S+";
                  interfaceGroups = [
                    [
                      "ether1"
                      "ether4"
                      "ether5"
                      "ether6"
                      "ether7"
                      "ether8"
                      "ether9"
                      "ether10"
                      "ether11"
                      "ether12"
                      "ether13"
                      "ether14"
                      "ether15"
                      "ether16"
                      "sfp+1"
                      "sfp+2"
                    ]
                    [
                      "ether2"
                      "ether3"
                    ]
                  ];
                  interfaces = {
                    "lag1" = {
                      type = "bridge";
                      virtual = true;
                    };
                    "sfp+1" = {
                      addresses = [
                        "192.168.248.3"
                      ];
                      network = "home";
                      sharesNetworkWith = [ (lib.const true) ];
                      type = "fiber-duplex";
                    };
                    "sfp+2".type = "fiber-duplex";
                  };
                };
                work-kvm = mkDevice "Work KVM" {
                  deviceType = "device";
                  hardware = {
                    info = "GL.inet KVM";
                    image = ./glinet.png;
                  };
                  interfaces.ether1 = {
                    addresses = [
                      "DHCP"
                    ];
                    network = "work";
                  };
                };
                work-router = mkRouter "Work Router" {
                  connections = {
                    ether1 = [
                      (mkConnection "work-switch" "ether2")
                    ];
                    ether2 = [
                      (mkConnection "work-windows" "ether1")
                    ];
                    ether3 = [
                      (mkConnection "pve-work" "nic0")
                      (mkConnection "pve-work" "vmbr0")
                    ];
                    ether4 = [
                      (mkConnection "gns3-work" "enp193s0")
                    ];
                    ether5 = [
                      (mkConnection "work-kvm" "ether1")
                    ];
                  };
                  hardware.image = ./hapax2.png;
                  icon = "devices.mikrotik";
                  info = "Mikrotik hAP-ax2";
                  interfaceGroups = [
                    [
                      "ether1"
                    ]
                    [
                      "ether2"
                      "ether3"
                      "ether4"
                      "ether5"
                      "wifi1"
                      "wifi2"
                    ]
                    [ "wg0" ]
                  ];
                  interfaces = {
                    ether2 = {
                      addresses = [
                        "192.168.20.1"
                      ];
                      network = "work";
                      sharesNetworkWith = [
                        (ether3: true)
                        (ether4: true)
                        (ether5: true)
                        (wifi1: true)
                        (wifi2: true)
                      ];
                    };
                    wg0.type = "wireguard";
                  };
                };
                work-switch = mkSwitch "Work Switch" {
                  connections = {
                  };
                  hardware.image = ./rb260gs.png;
                  icon = "devices.mikrotik";
                  info = "Mikrotik RB260GS";
                  interfaceGroups = [
                    [
                      "ether1"
                      "ether2"
                      "ether3"
                      "ether4"
                      "sfp"
                    ]
                    [
                      "ether2"
                    ]
                  ];
                };
                work-windows = mkDevice "Work Windows" {
                  deviceType = "device";
                  hardware.info = "Dell Mini";
                  icon = "devices.desktop";
                  interfaces.ether1 = {
                    addresses = [
                      "DHCP"
                    ];
                    network = "work";
                  };
                };
              };
          }
        )
      ];
    };
}
