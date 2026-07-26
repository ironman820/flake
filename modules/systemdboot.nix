{
  flake.nixosModules.systemdboot = {
    boot.loader = {
      grub.enable = false;
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
    };
  };
}
