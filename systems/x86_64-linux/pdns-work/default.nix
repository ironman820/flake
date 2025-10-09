_: {
  imports = [
    ./hardware.nix
    ./networking.nix
  ];

  config = {
    mine = {
      suites.server.enable = true;
      servers = {
        dns = {
          auth = true;
          enable = true;
          recursor = {
            forwards = {
              "niceastman.com" = "192.168.254.2";
              "home.niceastman.com" = "192.168.254.2";
              "desk.niceastman.com" = "127.0.0.1:5300";
            };
          };
        };
        # postgresql.pgadmin.enable = true;
      };
      virtual.guest.enable = true;
    };
    system.stateVersion = "23.05";
  };
}
