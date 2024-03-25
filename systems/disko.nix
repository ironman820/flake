{
  bootSize ? "512M",
  device ? throw "Please set device to your hard drive",
  swapSize ? "8G",
  ...
}: {
  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = bootSize;
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          swap = {
            size = swapSize;
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
          extraArgs = ["-f"];
          subvolumes = let
            mountOpts = ["compress=zstd"];
          in {
            "/root" = {
              mountpoint = "/";
              mountOptions = mountOpts ++ ["subvol=root"];
            };
            "/nix" = {
              mountpoint = "/nix";
              mountOptions = mountOpts ++ ["subvol=nix" "noatime"];
            };
            "/persist" = {
              mountpoint = "/persist";
              mountOptions = mountOpts ++ ["subvol=persist" "noatime"];
            };
          };
          mountpoint = "/partition-root";
        };
      };
    };
  };
}
