{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.servers.tftp;
in {
  options.mine.servers.tftp = {
    enable = mkEnableOption "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf config.mine.networking.basic.firewall {
      allowedUDPPorts = [
        69
      ];
    };
    services.atftpd = {
      enable = true;
      root = "/etc/tftp";
    };
  };
}
