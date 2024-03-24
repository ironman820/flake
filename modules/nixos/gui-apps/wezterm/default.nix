{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine.user.settings.applications) terminal;
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.gui-apps.wezterm;
in {
  options.mine.gui-apps.wezterm = {
    enable = mkBoolOpt (terminal == "wezterm") "Enable the module";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.wezterm
    ];
  };
}
