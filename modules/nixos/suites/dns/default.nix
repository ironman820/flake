{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.mine) enabled mkBoolOpt;
  cfg = config.mine.servers.dns;
in {
  options.mine.servers.dns = {
    enable = mkEnableOption "Enable or disable tftp support";
    auth = mkBoolOpt false "Enabled the Authoritative DNS server";
    dnsdist = mkBoolOpt false "Enable DNS-Dist to handle calls to proper servers";
  };

  config = mkIf cfg.enable {
    mine.servers = {
      dns.recursor = enabled;
      pdns-auth.enable = cfg.auth;
    };
    environment.systemPackages = with pkgs; [
      dig
    ];
    networking.firewall = mkIf config.mine.networking.firewall {
      allowedTCPPorts = [
        53
      ];
      allowedUDPPorts = [
        53
      ];
    };
  };
}
