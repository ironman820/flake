{lib, ...}: let
  inherit (lib.ironman) enabled;
in {
  imports = [./hardware.nix ./networking.nix];

  config = {
    ironman = {
      suites.server = {
        enable = true;
        # vaultwarden = enabled;
      };
    };
    system.stateVersion = "23.05";
  };
}
