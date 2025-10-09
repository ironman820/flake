{
  flake.diskoConfigurations.friday = {
    disko.devices = {
      disk = {
        main = {
          device = "/dev/nvme1n1";
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
                size = "8G";
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
        secondary = {
          device = "/dev/nvme0n1";
          type = "disk";
          content = {
            type = "gpt";
            partitions.home = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "home_vg";
              };
            };
          };
        };
      };
      lvm_vg = {
        root_vg = {
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
                    mountOptions = mountOpts ++ [ "subvol=root" ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = mountOpts ++ [
                      "subvol=nix"
                      "noatime"
                    ];
                  };
                };
              mountpoint = "/partition-root";
            };
          };
        };
        home_vg = {
          type = "lvm_vg";
          lvs.home = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes =
                let
                  mountOpts = [ "compress=zstd" ];
                in
                {
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = mountOpts ++ [ "subvol=home" ];
                  };
                  "/ironman" = {
                    mountpoint = "/home/ironman";
                    mountOptions = mountOpts ++ [ "subvol=ironman" ];
                  };
                  "/root" = {
                    mountpoint = "/root";
                    mountOptions = mountOpts ++ [ "subvol=root_home" ];
                  };
                };
            };
          };
        };
      };
    };
  };
}
