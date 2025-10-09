{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.gui-apps.thunar;
in {
  options.mine.gui-apps.thunar = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };
  };
}
