{ lib, pkgs, ... }:
let
  inherit (lib.ironman) enabled;
in {
  imports = [ ./hardware.nix ./networking.nix ];

  config = {
    environment.systemPackages = with pkgs; [ openssl ];
    ironman = {
      suites.server = {
        enable = true;
        rcm2 = enabled;
      };
      virtual.guest = enabled;
    };

    system.stateVersion = "23.05";
  };

}
