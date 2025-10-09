{
  lib,
  pkgs,
  ...
}:
with lib;
with lib.mine; {
  imports = [
    ./hardware.nix
    ./networking.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      devenv
      openssl
    ];
    mine = {
      suites = {
        server.enable = true;
        servers.rcm = enabled;
      };
      virtual.guest.enable = true;
    };

    system.stateVersion = "23.05";
  };
}
