{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.gui-apps.floorp;
  app = config.mine.user.settings.applications.browser;
in {
  options.mine.gui-apps.floorp = {
    enable = mkBoolOpt (app == "floorp") "Enable the module";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.floorp
    ];
  };
}
