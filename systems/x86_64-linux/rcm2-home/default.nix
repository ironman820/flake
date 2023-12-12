{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.ironman) enabled;
in {
  imports = [ ./hardware.nix ./networking.nix ];

  config = {
    environment.systemPackages = with pkgs; [ openssl ];
    ironman = {
      sops.secrets.rcm2-env = {
        format = "binary";
        group = config.users.groups.users.name;
        mode = "0400";
        owner = config.ironman.user.name;
        path = "/data/rcm/.env";
        restartUnits = mkIf config.ironman.suites.server.rcm2.service [ "django.service" ];
        sopsFile = ./secrets/rcm2.env.age;
      };
      suites.server = {
        enable = true;
        rcm2 = {
          enable = true;
          hostname = "rcm2.home.niceastman.com";
        };
      };
      virtual.guest = enabled;
    };

    system.stateVersion = "23.05";
  };

}
