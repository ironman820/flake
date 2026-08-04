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
    device = "/dev/mapper/pve-vm--120--disk--0";
    fsType = "ext4";
  };

  swapDevices = [ ];
}
