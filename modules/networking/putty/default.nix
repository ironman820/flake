{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.networking.putty;
in {
  options.ironman.networking.putty = with types; {
    enable = mkBoolOpt false "Whether or not to enable putty.";
  };

  config = mkIf cfg.enable {
    ironman = {
      home.extraOptions.home.packages = [ pkgs.putty ];
      user.extraGroups = [
        "dialout"
      ];
    };
  };
}