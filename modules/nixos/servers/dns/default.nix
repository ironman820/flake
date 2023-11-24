{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.ironman) enabled mkBoolOpt;
  cfg = config.ironman.servers.dns;
in
{
  options.ironman.servers.dns = {
    enable = mkEnableOption "Enable or disable tftp support";
    auth = mkBoolOpt false "Enabled the Authoritative DNS server";
    dnsdist = mkBoolOpt false "Enable DNS-Dist to handle calls to proper servers";
  };

  config = mkIf cfg.enable {
    ironman.servers = {
      dns.recursor = enabled;
      pdns-auth.enable = cfg.auth;
    };
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
