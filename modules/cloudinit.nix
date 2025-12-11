{
  flake.nixosModules.cloud-init = {
    networking.useDHCP = false;
    services.cloud-init = {
      enable = true;
      config = ''
        disable_ec2_metadata: True
        datasource_list: [ "NoCloud" ]
      '';
      network.enable = true;
    };
  };
}
