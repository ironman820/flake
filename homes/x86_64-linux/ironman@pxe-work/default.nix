{ config, lib, ...}:
let inherit (lib.ironman) enabled;
in {
  ironman.home = {
    suites.server = enabled;
    user.name = config.snowfallorg.user.name;
  };
}
