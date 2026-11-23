{
  flake.nixosModules.cloud-init = { config, ... }: {
    boot = {
      tmp.cleanOnBoot = true;
      growPartition = true;
    };
    networking = {
      dhcpcd.enable = false;
      useDHCP = false;
      useNetworkd = true;
      wireless.enable = false;
    };
    services = {
      cloud-init = {
        enable = true;
        network.enable = true;
        settings = {
          datasource_list = [
            "NoCloud"
            "ConfigDrive"
          ];
          ssh_pwauth = false;
          disable_root = true;
          preserve_hostname = false;
          manage_etc_hosts = false;
          chpasswd.expire = false;
          users = [
            config.ironman.user.name
          ];
        };
      };
      resolved = {
        enable = true;
        settings.Resolve.DNSSEC = "false";
      };
    };
  };
}
