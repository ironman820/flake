{
  cell,
  config,
  inputs,
}: let
  inherit (cell) nixosSuites;
  inherit (inputs) nixpkgs;
  inherit (inputs.cells) mine;
  l = nixpkgs.lib // mine.lib // builtins;
  p = cell.nixosProfiles;
  v = config.vars;
in {
  imports = let
    profiles = with p; [
      static-ip
      virtual-guest
    ];
    suites = nixosSuites.server;
  in
    l.concatLists [
      [
        cell.bee
        cell.hardwareProfiles.traefik-work
      ]
      profiles
      suites
    ];

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
    defaultGateway = "192.168.20.1";
    interfaces."ens18".ipv4.addresses = [
      {
        address = "192.168.20.4";
        prefixLength = 24;
      }
    ];
    nameservers = [
      "192.168.20.2"
    ];
  };
}
