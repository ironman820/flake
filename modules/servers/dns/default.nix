{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.dns;
in
{
  options.ironman.dns = {
    enable = mkEnableOption "Enable or disable tftp support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dig
    ];
    networking.firewall = {
      allowedTCPPorts = [
        53
      ];
      allowedUDPPorts = [
        53
      ];
    };
  };
}
