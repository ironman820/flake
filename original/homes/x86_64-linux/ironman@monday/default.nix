{lib, ...}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    ../modules.nix
  ];
  mine.home = {
    de.hyprland = {
      enable = true;
    };
    networking = enabled;
    personal-apps = enabled;
    suites.workstation = enabled;
  };
}
