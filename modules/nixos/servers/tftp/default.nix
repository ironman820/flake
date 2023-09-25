{ config, inputs, lib, options, pkgs, ... }:
with lib;
with lib.ironman;
let
  cfg = config.ironman.servers.tftp;
in
{
  options.ironman.servers.tftp = {
    enable = mkBoolOpt false "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [
      69
    ];
    services.atftpd = {
      enable = true;
      root = "/etc/tftp";
    };
  };
}
