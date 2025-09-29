{lib, ...}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    ../modules.nix
  ];
  mine.home.suites.workstation = enabled;
  snowfallorg.user = enabled;
}
