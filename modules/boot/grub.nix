{
  flake.nixosModules.boot-grub = _: {
    boot = {
      loader.grub = {
        efiSupport = true;
        device = "nodev";
        darkmatter-theme = {
          enable = true;
          style = "nixos";
          icon = "color";
          resolution = "1080p";
        };
      };
      plymouth.enable = true;
    };
  };
}
