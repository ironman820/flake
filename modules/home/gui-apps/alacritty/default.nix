{
  lib,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkDefault mkForce mkIf;
  inherit (lib.mine) mkBoolOpt mkOpt;
  inherit (lib.types) float;

  cfg = config.mine.home.gui-apps.alacritty;
  os = osConfig.mine.gui-apps.alacritty;
in {
  options.mine.home.gui-apps.alacritty = {
    enable = mkBoolOpt os.enable "Enable the module";
    opacity = mkOpt float config.mine.home.stylix.terminalOpacity "Set Alacritty's opacity";
  };
  config = mkIf cfg.enable {
    mine.home.de.hyprland.windowrulev2 = [
      "noblur,class:(Alacritty)"
      "noborder,class:(Alacritty)"
      "nodim,class:(Alacritty)"
      "noshadow,class:(Alacritty)"
      "rounding 0,class:(Alacritty)"
      "opacity 1.0 override 1.0 override,class:^(Alacritty)$"
    ];
    programs.alacritty = {
      inherit (cfg) enable;
      settings = {
        font = mkDefault {
          normal = {
            family = "FiraCode Nerd Font";
            style = "Regular";
          };
          size = 12;
        };
        window = {
          opacity = mkForce cfg.opacity;
          padding = {
            x = 5;
            y = 5;
          };
        };
      };
    };
  };
}
