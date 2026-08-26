{
  flake.nixosModules.boot = { lib, ... }: {
    boot = {
      kernelParams = [
        "quiet"
      ];
      loader = {
        grub = {
          efiSupport = true;
          device = "nodev";
          timeoutStyle = "hidden";
        };
        efi.canTouchEfiVariables = true;
      };
      plymouth.enable = lib.mkDefault true;
    };
  };
}
