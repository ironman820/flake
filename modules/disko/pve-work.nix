{
  flake.diskoConfigurations.pve-work = {
    disko.devices = {
      disk = {
        main = {
          device = "/dev/nvme0n1";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                name = "boot";
                size = "1M";
                type = "EF02";
              };
              esp = {
                name = "ESP";
                size = "500M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
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
        storage = {
          device = "/dev/sda";
          type = "disk";
          content = {
            type = "gpt";
            partitions.storage = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "storage_vg";
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
                  mountOpts = [
                    "compress=zstd"
                  ];
                in
                {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = mountOpts ++ [
                      "subvol=root"
                    ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = mountOpts ++ [
                      "subvol=nix"
                      "noatime"
                    ];
                  };
                };
            };
          };
        };
        storage_vg = {
          type = "lvm_vg";
          lvs.vms = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/var/lib/microvms";
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
  };
}
