{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.personal-apps;
in
{
  options.mine.home.personal-apps = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      calibre
    ];
  };
}
