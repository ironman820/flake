{
  flake.nixosModules.friday-hardware =
    {
      config,
      lib,
      ...
    }:
    {
      boot = {
        initrd = {
          availableKernelModules = [
            "nvme"
            "xhci_pci"
            "usb_storage"
            "sd_mod"
          ];
          kernelModules = [ ];
        };
        kernelModules = [ "kvm-amd" ];
        extraModulePackages = [ ];
      };
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
