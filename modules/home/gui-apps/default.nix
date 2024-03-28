{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.gui-apps;
  os = osConfig.mine.gui-apps;
in {
  options.mine.home.gui-apps = {
    enable = mkBoolOpt os.enable "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    home = {
      file."putty/sessions/FS Switch".source = ./config/putty/${"FS%20Switch"};
      sessionVariables = {BROWSER = config.mine.home.user.settings.applications.browser;};
    };
    services.udiskie = {
      enable = true;
      tray = "never";
    };
  };
}
