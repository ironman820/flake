{
  flake.nixosModules.boot-systemd = _: {
    boot = {
      loader = {
        grub.enable = false;
        systemd-boot.enable = true;
      };
    };
  };
}
