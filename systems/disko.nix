{device ? throw "Please set device to your hard drive", ...}: {
  disko.devices = {
    disk.main = {
      inherit device;
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
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = let
                mountOpts = ["compress=zstd"];
              in {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = mountOpts;
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = mountOpts ++ ["noatime"];
                };
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = mountOpts ++ ["noatime"];
                };
              };
              mountpoint = "/partition-root";
            };
          };
        };
      };
    };
  };
}
