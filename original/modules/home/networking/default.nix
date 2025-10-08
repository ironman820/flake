{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.home.networking;
in {
  options.mine.home.networking = {
    enable = mkEnableOption "Setup networkmanager-dmenu";
  };

  config = mkIf cfg.enable {
    xdg.configFile."networkmanager-dmenu/config.ini".source = ./nm-dmenu.ini;
  };
}
