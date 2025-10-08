{lib, ...}: let
  inherit (lib.mine) enabled;
in {
  imports = [./hardware.nix ./networking.nix];

  config = {
    mine = {
      suites.server = {
        enable = true;
        # vaultwarden = enabled;
      };
    };
    system.stateVersion = "23.05";
  };
}
