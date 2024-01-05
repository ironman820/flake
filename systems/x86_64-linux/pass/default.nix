{ lib, ... }:
let inherit (lib.royell) enabled;
in {
  imports = [ ./hardware.nix ./networking.nix ];

  config = {
    ironman = {
      suites.server = {
        enable = true;
        vaultwarden = enabled;
      };
    };
    system.stateVersion = "23.05";
  };
}
