{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.home.swappy;
in {
  options.mine.home.swappy = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      swappy
    ];
    xdg.configFile."swappy/config".text = ''
      [Default]
      save_dir=/home/${config.mine.home.user.name}/Pictures/01-Screenshots
      save_filename_format=screenshot-%Y%m%d-%H%M%S.png
      show_panel=false
      line_size=5
      text_size=20
      text_font=sans-serif
      paint_mode=brush
      early_exit=false
      fill_shape=false
    '';
  };
}
