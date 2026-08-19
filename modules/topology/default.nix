{
  self,
  ...
}:
{
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
              devices.mikrotik.file = ./mikrotik-white.svg;
              services.technitium.file = ./technitium.png;
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
            nodes = with config.lib.topology; {
              ap = mkDevice "AP" {
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
                connections = mkConnection "router" "ether1";
              };
              nas = mkDevice "NAS" {
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
              router = mkRouter "Router" {
                connections.sfp-sfpplus1 = [
                  (mkConnection "switch" "sfp+1")
                  (mkConnection "switch" "sfp+2")
                ];
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
                  wg0 = {
                    type = "wireguard";
                  };
                };
              };
              switch = mkSwitch "Switch" {
                connections = {
                  ether1 = mkConnection "ap" "ether1";
                  ether2 = mkConnection "nas" "ether1";
                  ether3 = mkConnection "nas" "ether2";
                  ether4 = [
                    (mkConnection "pve2" "enp1s0")
                    (mkConnection "pve2" "br0")
                  ];
                  lag1 = mkConnection "nas" "lag1";
                };
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
            };
          }
        )
      ];
    };
}
