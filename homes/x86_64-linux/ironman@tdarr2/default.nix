{lib, ...}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    ../modules.nix
  ];
  mine.home = {
    programs = {ranger = enabled;};
    sops.install = true;
    suites.server = enabled;
  };
}
