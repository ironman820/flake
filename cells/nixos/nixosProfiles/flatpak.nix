{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.tui.flatpak;
in {
  options.mine.tui.flatpak = {
    enable = mkEnableOption "Enable the module";
  };
  config = mkIf cfg.enable {
    services.flatpak = {
      inherit (cfg) enable;
    };
  };
}
