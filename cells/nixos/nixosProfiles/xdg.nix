{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.mine.xdg;
in {
  options.mine.xdg = {
    enable = mkEnableOption "Enable xdg";
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      inherit (cfg) enable;
      config.common.default = "*";
      wlr = {
        inherit (config.mine.de.hyprland) enable;
      };
      xdgOpenUsePortal = true;
    };
  };
}
