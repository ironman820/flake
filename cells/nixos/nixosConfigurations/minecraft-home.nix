{
  cell,
  config,
  inputs,
}: let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  p = cell.nixosProfiles;
  v = config.vars;
in {
  imports = let
    profiles = with p; [
      minecraft
      docker
      personal-drives
      static-ip
      virtual-guest
    ];
    suites = cell.nixosSuites.server;
  in
    l.concatLists [
      [
        cell.bee
        cell.hardwareProfiles.proxmox
      ]
      profiles
      suites
    ];

  disko.devices = cell.diskoConfigurations.common;

  home-manager.users.${v.username} = {
    imports = let
      inherit (inputs.cells.home) homeSuites;
      # h = inputs.cells.home.homeProfiles;
      profiles = [];
      suites = homeSuites.server;
    in
      l.concatLists [
        profiles
        suites
      ];
  };

  networking = {
    defaultGateway = "192.168.254.1";
    hostName = "minecraft";
    interfaces."ens18".ipv4.addresses = [
      {
        address = "192.168.254.8";
        prefixLength = 24;
      }
    ];
    nameservers = [
      "192.168.254.2"
    ];
  };
}
