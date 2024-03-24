{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.home.sync;
  imp = config.mine.home.impermanence.enable;
in {
  options.mine.home.sync = {
    enable = mkEnableOption "Enable the default settings?";
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
