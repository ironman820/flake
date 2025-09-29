{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.servers.sync;
  os = osConfig.mine.servers.sync;
in {
  options.mine.home.servers.sync = {
    enable = mkBoolOpt os.enable "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      # tray.enable = true;
    };
  };
}
