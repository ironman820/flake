{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.home.hyprlock;
in {
  options.mine.home.hyprlock = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    programs.hyprlock = {
      inherit (cfg) enable;
      backgrounds = [
        {
          path = "/home/${config.mine.home.user.name}/.config/flake/modules/home/hyprlock/files/suit_up.png";
          blur_passes = 4;
          blur_size = 2;
          vibrancy_darkness = 0.0;
        }
      ];
      input-fields = [
        {
          outline_thickness = 1;
        }
      ];
      labels = [
        {
          text = "";
        }
      ];
    };
  };
}
