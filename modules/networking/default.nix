{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.networking;
in
{
  options.ironman.networking = with types; {
    address = mkOpt str "" "IP Address";
    dhcp = mkBoolOpt true "Enable DHCP?";
    enable = mkBoolOpt true "Enable or disable sops support";
    gateway = mkOpt str "" "Default Gateway";
    interface = mkOpt str "" "Interface to configure";
    nameservers = mkOpt (listOf str) [ ] "Nameservers";
    network = mkOpt str "" "Network listing used for services.";
    prefix = mkOpt int 24 "Subnet Mask Prefix";
  };

  config = mkIf cfg.enable {
    networking = {
      defaultGateway = mkIf (cfg.dhcp == false) {
        address = cfg.gateway;
      };
      dhcpcd.enable = cfg.dhcp;
      interfaces = mkIf (builtins.stringLength cfg.interface > 0) {
        ${cfg.interface}.ipv4.addresses = [
          {
            address = cfg.address;
            prefixLength = cfg.prefix;
          }
        ];
      };
      nameservers = mkAliasDefinitions options.ironman.networking.nameservers;
    };
  };
}
