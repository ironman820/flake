{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.gui-apps.winbox;
  os = osConfig.mine.gui-apps.winbox;
in {
  options.mine.home.gui-apps.winbox = {
    enable = mkBoolOpt os.enable "Enable the module";
  };
  config = mkIf cfg.enable {
    mine.home.de.hyprland = {
      windowrule = [
        "workspace 3,^(winbox.exe)$"
      ];
      windowrulev2 = [
        "tile,class:(winbox.exe)"
      ];
    };
  };
}
