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
    x64-linux
  ]);
  boot.plymouth.enable = false;
  home-manager = {
    users.ironman = self.homeConfigurations.ironman-server;
  };
  networking = {
    interfaces = {
      ens18 = {
        ipv4.addresses = [
          {
            address = "192.168.20.2";
            prefixLength = 23;
          }
        ];
      };
    };
    defaultGateway = {
      address = "192.168.20.1";
      interface = "ens18";
    };
    nameservers = [
      "192.168.0.10"
      "208.80.144.50"
      "208.80.144.51"
    ];
    useDHCP = false;
  };
  security.sudo.wheelNeedsPassword = false;
  services = {
    qemuGuest.enable = true;
    technitium-dns-server = {
      enable = true;
      openFirewall = true;
    };
    xserver.enable = false;
  };
  users.users.ironman.extraGroups = [
    "networkmanager"
  ];
}
