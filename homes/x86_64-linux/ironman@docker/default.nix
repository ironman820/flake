{ lib, ... }:
let inherit (lib.ironman) enabled;
in {
  ironman.home = {
    programs = { ranger = enabled; };
    sops.install = true;
    suites.server = enabled;
  };
}
