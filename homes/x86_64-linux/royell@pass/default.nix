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
    ranger = enabled;
    suites.server = enabled;
    user.name = config.snowfallorg.user.name;
  };
}
