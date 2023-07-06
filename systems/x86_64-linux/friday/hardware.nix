{ modulesPath, lib, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" =
      { device = "/dev/disk/by-uuid/5781c99b-de31-4eb4-88ec-7fcd7bb5ac57";
        fsType = "ext4";
      };

    "/boot" =
      { device = "/dev/disk/by-uuid/672B-C6A0";
        fsType = "vfat";
      };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  swapDevices = [ ];
}
