{
  lib,
  config,
  ...
}: let
  inherit (config.mine.home.user.settings) terminal;
  inherit (lib) mkDefault mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.alacritty;
in {
  options.mine.home.alacritty = {
    enable = mkBoolOpt (terminal == "alacritty") "Enable the module";
  };
  config = mkIf cfg.enable {
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
          padding = {
            x = 5;
            y = 5;
          };
          opacity = mkDefault 0.7;
        };
      };
    };
  };
}
