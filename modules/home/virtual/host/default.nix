{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.home.virtual.host;
in {
  options.ironman.home.virtual.host = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      virt-manager
    ];
  };
}
