{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (config.mine.home.user.settings.applications) browser terminal;
  inherit (lib) mkIf;
  inherit (lib.mine) enabled mkBoolOpt;

  cfg = config.mine.home.suites.workstation;
  os = osConfig.mine.suites.workstation;
in {
  options.mine.home.suites.workstation = {
    enable = mkBoolOpt os.enable "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    mine.home = {
      gui-apps = {
        alacritty = mkIf (terminal == "alacritty") enabled;
        contour = mkIf (terminal == "contour") enabled;
        floorp = mkIf (browser == "floorp") enabled;
        kitty = mkIf (terminal == "kitty") enabled;
        wezterm = mkIf (terminal == "wezterm") enabled;
      };
      hardware.yubikey = enabled;
      tui.neomutt = enabled;
      video-tools = enabled;
      virtual.host = enabled;
    };
    services.udiskie = enabled;
  };
}
