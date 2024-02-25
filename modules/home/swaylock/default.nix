{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.home.swaylock;
in {
  options.mine.home.swaylock = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    programs.swaylock = {
      inherit (cfg) enable;
      package = pkgs.swaylock-effects;
      settings = {
        ignore-empty-password = true;
        clock = true;
        timestr = "%R";
        datestr = "%a, %e of %B";
        screenshots = true;
        fade-in = 3;
        effect-pixelate = 5;
        effect-vignette = "0.3:0.5";
        indicator = true;
        indicator-radius = 300;
        indicator-thickness = 10;
        indicator-caps-lock = true;
      };
    };
  };
}
