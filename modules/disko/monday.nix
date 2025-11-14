{
  flake.diskoConfigurations.monday = {
    disko.devices = {
      disk.main = {
        device = "/dev/mmcblk0";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              size = "3G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            root = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "root_vg";
              };
            };
          };
        };
      };
      lvm_vg.root_vg = {
        type = "lvm_vg";
        lvs.root = {
          size = "100%FREE";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            subvolumes =
              let
                mountOpts = [ "compress=zstd" ];
              in
              {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = mountOpts;
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = mountOpts ++ [
                    "noatime"
                  ];
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = mountOpts;
                };
                "/home/ironman" = {
                  mountpoint = "/home/ironman";
                  mountOptions = mountOpts;
                };
                "/home/root" = {
                  mountpoint = "/root";
                  mountOptions = mountOpts;
                };
              };
          };
        };
      };
    };
  };
}
