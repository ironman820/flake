{ config, lib, pkgs, system, ... }:

with lib;
with lib.ironman;
let
  cfg = config.ironman.home.personal-apps;
in
{
  options.ironman.home.personal-apps = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf (cfg.enable && config.ironman.home.gnome.enable) {
    home.packages = with pkgs; [
      calibre
    ];
  };
}
