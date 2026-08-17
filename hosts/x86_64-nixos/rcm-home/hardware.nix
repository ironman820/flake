{
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
      ];
    };
    kernelModules = [ "kvm-amd" ];
  };

  fileSystems."/" = {
    device = "/dev/mapper/ThinStorage-vm--121--disk--0";
    fsType = "ext4";
  };

  swapDevices = [ ];
}
