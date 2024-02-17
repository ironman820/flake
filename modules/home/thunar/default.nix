{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.home.thunar;
in {
  options.mine.home.thunar = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs.xfce; [
      thunar
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-volman
    ];
  };
}
