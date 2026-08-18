{
  flake.diskoConfigurations.pve2 = {
    disko.devices = {
      nodev."/" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=25%"
          "mode=755"
        ];
      };
      disk.main = {
        device = "/dev/sda";
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
      lvm_vg.root_vg = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "128G";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = let
                mountOpts = [
                  "compress=zstd"
                ];
              in {
                # "/root" = {
                #   mountpoint = "/";
                #   mountOptions = mountOpts;
                # };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = mountOpts ++ [
                    "subvol=nix"
                    "noatime"
                  ];
                };
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = mountOpts ++ [
                    "subvol=persist"
                    "noatime"
                  ];
                };
              };
            };
          };
          vms = {
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
