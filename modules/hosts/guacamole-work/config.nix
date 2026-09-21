{ self, ... }: {
  flake.nixosModules.guacamoleWorkConfig = { config, ... }: {
    hardware.facter.reportPath = ./facter.json;
    ironman.guacamole = {
      enable = true;
      userMappingXml = config.sops.secrets.workUserMappingXml.path;
    };
    networking = {
      defaultGateway = {
        address = "192.168.20.1";
        interface = "ens18";
      };
      hostName = "rdp-work";
      interfaces.ens18.ipv4.addresses = [
        {
          address = "192.168.20.103";
          prefixLength = 23;
        }
      ];
      nameservers = [
        "192.168.20.2"
      ];
      useDHCP = false;
    };
    services.guacamole-client.settings.log-level = "debug";
    sops.secrets.workUserMappingXml = {
      sopsFile = "${self.outPath}/.secrets/guacamole.yaml";
      mode = "0444";
    };
  };
}
