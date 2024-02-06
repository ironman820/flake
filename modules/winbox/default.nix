{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.winbox;
in {
  options.mine.winbox = {
    enable = mkEnableOption "Enable the default settings?";
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf config.mine.networking.firewall {
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
