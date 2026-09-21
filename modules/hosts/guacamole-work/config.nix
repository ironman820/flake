{ self, ... }: {
  flake.nixosModules.guacamoleWorkConfig = { config, ... }: {
    hardware.facter.reportPath = ./facter.json;
    ironman.guacamole = {
      enable = true;
      userMappingXml = config.sops.secrets.workUserMappingXml.path;
    };
    networking = {
      hostName = "rdp-work";
      # nameservers = [
      #   "208.80.144.50"
      #   "208.80.144.51"
      # ];
    };
    services.guacamole-client.settings.log-level = "debug";
    sops.secrets.workUserMappingXml = {
      sopsFile = "${self.outPath}/.secrets/guacamole.yaml";
      mode = "0444";
    };
  };
}
