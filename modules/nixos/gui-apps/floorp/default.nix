{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.gui-apps.floorp;
in {
  options.mine.gui-apps.floorp = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.floorp
    ];
  };
}
