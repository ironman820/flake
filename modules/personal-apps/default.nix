{ config, lib, pkgs, system, ... }:

with lib;
let
  cfg = config.ironman.personal-apps;
in
{
  options.ironman.personal-apps = with types; {
    enable = mkBoolOpt false "Enable the default settings?";
  };

  config = mkIf (cfg.enable && config.ironman.gnome.enable) {
    ironman.home.extraOptions.home.packages = with pkgs; [
      calibre
    ];
  };
}
