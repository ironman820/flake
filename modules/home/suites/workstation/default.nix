{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (config.mine.home.user.settings.applications) terminal;
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
      de.hyprland = enabled;
      gui-apps = {
        alacritty = mkIf (terminal == "alacritty") enabled;
        wezterm = mkIf (terminal == "wezterm") enabled;
      };
      hardware.yubikey = enabled;
      rofi = enabled;
      servers.sync = enabled;
      tui.neomutt = enabled;
      video-tools = enabled;
      virtual.host = enabled;
    };
  };
}
