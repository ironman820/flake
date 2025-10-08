{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine.user.settings.applications) terminal;
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.gui-apps.contour;
in {
  options.mine.gui-apps.contour = {
    enable = mkBoolOpt (terminal == "contour") "Enable the module";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.contour
    ];
  };
}
