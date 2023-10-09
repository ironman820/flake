{ config, format, home, host, inputs, lib, pkgs, systems, target, virtual, ...}:
let
  inherit (lib.ironman) enabled;
in
{
  ironman.home = {
    personal-apps = enabled;
    suites.virtual-workstation = enabled;
    user.name = config.snowfallorg.user.name;
  };
}
