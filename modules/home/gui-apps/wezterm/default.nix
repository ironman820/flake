{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.gui-apps.wezterm;
  os = osConfig.mine.gui-apps.wezterm;
in {
  options.mine.home.gui-apps.wezterm = {
    enable = mkBoolOpt os.enable "Enable the module";
  };
  config = mkIf cfg.enable {
    programs.wezterm = {
      inherit (cfg) enable;
      enableZshIntegration = false;
      # extraConfig = ''
      #   return {
      #     color_scheme = "Catppuccin Mocha",
      #   }
      # '';
    };
  };
}
