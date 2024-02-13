{ config, format, home, host, inputs, lib, pkgs, systems, target, virtual, ...}:
let
  inherit (lib.ironman) enabled;
in {
  ironman.home = {
    programs.ranger = enabled;
    suites.server = enabled;
    user.name = config.snowfallorg.user.name;
  };
}
