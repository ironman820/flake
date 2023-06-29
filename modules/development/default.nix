{ pkgs, config, lib, ... }:

with lib;
# with lib.internal;
let
  cfg = config.ironman.development;
in {
  options.ironman.development = with types; {
    enable = mkBoolOpt false "Whether or not to enable a desktop environment.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.devbox ];
  };
}