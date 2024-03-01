{
  config,
  lib,
  ...
}: let
  inherit (lib.mine) enabled;
in {
  imports = [
    ../modules.nix
  ];
  mine.home = {
    suites.virtual-workstation = enabled;
    user.name = config.snowfallorg.user.name;
  };
}
