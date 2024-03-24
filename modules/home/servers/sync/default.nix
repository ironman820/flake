{
  config,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.mine) mkBoolOpt;

  cfg = config.mine.home.servers.sync;
  imp = config.mine.home.impermanence.enable;
  os = osConfig.mine.servers.sync;
in {
  options.mine.home.servers.sync = {
    enable = mkBoolOpt os.enable "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    home.persistence."/persist/home".directories = mkIf imp [
      ".config/syncthing"
      ".local/share/syncthing"
    ];
    services.syncthing = {
      enable = true;
      # tray.enable = true;
    };
  };
}
