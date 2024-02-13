{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.home.personal-apps;
in
{
  options.ironman.home.personal-apps = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      calibre
    ];
  };
}
