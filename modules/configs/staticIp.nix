{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake.nixosModules.staticIP = moduleWithSystem (
    perSystem@{ ... }:
    { config, lib, ... }:
    let
      inherit (lib) mkOption;
      inherit (lib.types) int listOf str;
      cfg = config.ironman.staticIP;
    in
    {
      options.ironman.staticIP = {
        address = mkOption {
          description = "IP address to assign to the system";
          example = "192.168.0.5";
          type = str;
        };
        defaultGateway = mkOption {
          default = "192.168.248.1";
          description = "Default gateway for connectivity";
          example = "192.168.0.1";
          type = str;
        };
        interface = mkOption {
          default = "ens18";
          description = "The interface to add the address to";
          type = str;
        };
        nameservers = mkOption {
          default = [
            "192.168.248.2"
          ];
          description = "List of nameservers to check for dns";
          type = listOf str;
        };
        prefixLength = mkOption {
          default = 23;
          description = "Prefix length for the IP address to communicate on";
          type = int;
        };
      };
      config.networking = {
        inherit (cfg) defaultGateway nameservers;
        dhcpcd.enable = false;
        interfaces.${cfg.interface}.ipv4.addresses = [
          {
            inherit (cfg) address prefixLength;
          }
        ];
        useDHCP = false;
      };
    }
  );
}
