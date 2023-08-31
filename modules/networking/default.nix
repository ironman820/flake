{ config, inputs, lib, options, pkgs, ... }:
with lib;
let
  cfg = config.ironman.networking;
in
{
  options.ironman.networking = with types; {
    address = mkOption {
      default = "";
      description = "IP Address";
      type = str;
    };
    dhcp = mkOption {
      default = true;
      description = "Enable DHCP?";
      type = bool;
    };
    enable = mkEnableOption "Enable or disable sops support";
    gateway = mkOption {
      default = "";
      description = "Default Gateway";
      type = str;
    };
    interface = mkOption {
      default = "";
      description = "Interface to configure";
      type = str;
    };
    nameservers = mkOption {
      default = [ ];
      description = "Nameservers";
      type = listOf str;
    };
    prefix = mkOption {
      default = 24;
      description = "Subnet Mask Prefix";
      type = int;
    };
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
