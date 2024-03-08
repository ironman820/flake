{lib, ...}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    ../modules.nix
  ];
  mine.home = {
    gui-apps.hexchat = true;
    hyprland = {
      enable = true;
    };
    networking = enabled;
    personal-apps = enabled;
    suites.workstation = enabled;
  };
}
