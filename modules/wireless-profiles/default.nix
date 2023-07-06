{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.wireless-profiles;
in {
  options.ironman.wireless-profiles = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
    home = mkBoolOpt true "Load the home profiles";
  };
}
