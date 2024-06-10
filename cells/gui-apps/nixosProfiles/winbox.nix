{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.gui-apps.winbox;
in {
  options.mine.gui-apps.winbox = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf config.mine.networking.basic.firewall {
      allowedTCPPorts = [
        8291
      ];
      allowedUDPPorts = [
        5678
        20561
      ];
    };
  };
}
