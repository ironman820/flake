{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.home.networking;
  imp = config.mine.home.impermanence.enable;
in {
  options.mine.home.networking = {
    enable = mkEnableOption "Setup networkmanager-dmenu";
  };

  config = mkIf cfg.enable {
    mine.home.tui.just.rootPersist = mkIf imp [
      "mkdir -p /persist/root/etc/NetworkManager/system-connections"
    ];
    xdg.configFile."networkmanager-dmenu/config.ini".source = ./nm-dmenu.ini;
  };
}
