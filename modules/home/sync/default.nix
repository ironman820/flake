{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.home.sync;
in {
  options.mine.home.sync = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      # tray.enable = true;
    };
  };
}
