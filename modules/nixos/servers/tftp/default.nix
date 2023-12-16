{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.ironman.servers.tftp;
in
{
  options.ironman.servers.tftp = {
    enable = mkEnableOption "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf config.ironman.networking.firewall { allowedUDPPorts = [
      69
    ]; };
    services.atftpd = {
      enable = true;
      root = "/etc/tftp";
    };
  };
}
