{
  flake.nixosModules.boot-systemd = {
    boot.loader = {
      grub.enable = false;
      systemd-boot.enable = true;
    };
  };
}
