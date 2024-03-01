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
    personal-apps = enabled;
    suites.virtual-workstation = enabled;
    user.name = config.snowfallorg.user.name;
  };
}
