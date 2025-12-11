{
  flake.nixosModules.boot-grub-clean = {
    boot.loader.grub = {
      efiSupport = true;
      device = "nodev";
    };
  };
}
