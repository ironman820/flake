{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (builtins) toString;
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.gui-apps.floorp;
  imp = config.mine.home.impermanence.enable;
  tsp = config.mine.home.user.settings.transparancy;
  os = osConfig.mine.gui-apps.floorp;
in {
  options.mine.home.gui-apps.floorp = {
    enable = mkBoolOpt os.enable "Enable the module";
  };
  config = mkIf cfg.enable {
    mine.home.de.hyprland.windowrulev2 = [
      "opacity ${toString tsp.applicationOpacity} override ${toString tsp.inactiveOpacity} override,class:^(floorp)$"
      "opacity 1.0 override 1.0 override,class:^(floorp)$,title:(.*)(YouTube)(.*)"
    ];
    home.persistence."/persist/home".directories = mkIf imp [
      ".floorp"
    ];
  };
}
