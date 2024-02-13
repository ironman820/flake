{ config, lib, ...}:
let
  inherit (lib.ironman) enabled;
in
{
  ironman.home = {
    suites.virtual-workstation = enabled;
    user.name = config.snowfallorg.user.name;
  };
}
