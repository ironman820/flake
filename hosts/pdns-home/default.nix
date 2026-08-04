{
  inputs,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ./hardware.nix
    inputs.disko.nixosModules.disko
    self.diskoConfigurations.server
  ]
  ++ (with self.nixosModules; [
    grub
    git
    tmux
    x64-linux
  ]);
  boot.plymouth.enable = false;
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  networking = {
    firewall = {
      allowedTCPPorts = [
        22
        53
        80
        443
        538
        853
        5380
        53443
      ];
      allowedUDPPorts = [
        53
        538
        853
      ];
    };
    interfaces = {
      ens18 = {
        ipv4.addresses = [
          {
            address = "192.168.248.2";
            prefixLength = 23;
          }
        ];
      };
    };
    defaultGateway = {
      address = "192.168.248.1";
      interface = "ens18";
    };
    nameservers = [
      "208.80.144.50"
      "208.80.144.51"
    ];
    useDHCP = false;
  };
  security.sudo.wheelNeedsPassword = false;
  services = {
    chrony = {
      enable = true;
      extraConfig = ''
        allow
      '';
      servers = [
        "208.91.182.74"
      ];
    };
    qemuGuest.enable = true;
    technitium-dns-server.enable = true;
    xserver.enable = false;
  };
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
}
