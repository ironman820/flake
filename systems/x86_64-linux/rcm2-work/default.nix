{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) enabled;
in {
  imports = [./hardware.nix ./networking.nix];

  config = {
    environment.systemPackages = with pkgs; [openssl];
    mine = {
      sops.secrets.rcm2-env = {
        format = "binary";
        group = config.users.groups.users.name;
        mode = "0400";
        owner = config.mine.user.name;
        path = "/data/rcm/.env";
        restartUnits = mkIf config.mine.suites.server.rcm2.service ["django.service"];
        sopsFile = ./secrets/rcm2.env.age;
      };
      suites.server = {
        enable = true;
        rcm2 = {
          enable = true;
          service = true;
        };
      };
      virtual.guest = enabled;
    };

    system.stateVersion = "23.05";
  };
}
