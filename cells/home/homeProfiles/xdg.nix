{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.home.xdg;
in {
  options.mine.home.xdg = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    xdg = {
      inherit (cfg) enable;
    };
  };
}
